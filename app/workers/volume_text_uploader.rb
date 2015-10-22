class VolumeTextUploader
  include Sidekiq::Worker

  def perform(wiki)
    uploader  = build_mediawiki_uploader(wiki)
    volumes   = Volume.volume_pages

    volumes.each do |vol|
      begin
        # vol.start_upload!
        collection, *label, number = vol.name.split('-')
        # verify collection name??
        upload_templates(number, uploader)
        upload_compiled_texts(vol, number, uploader)
        upload_volume_category_page(vol, uploader)
        upload_karchag_category_page(vol, uploader)
        upload_text_category_page(vol, uploader)
        # vol.complete_upload!
      rescue AASM::InvalidTransition => state_machine_error
        puts state_machine_error
        state_machine_error
        ActionCable.server.broadcast 'alerts',
          message: 'state machine error',
          html_class: 'danger',
          text_decoration: 's', # strikethrough
          page_type: 'ERROR',
          page_name: "#{vol}"
      rescue => e
        puts "some error: #{vol.name}"
        puts e
      end
    end
    ActionCable.server.broadcast 'alerts',
      message: "Volumes & Texts have finished uploading.",
      html_class: "info"
  end

#=================================================
  private
#=================================================

    def upload_templates(volume_number, uploader)
      volume_templates = Volume.volume_templates
      volume_templates.each do |volume|
        volume.texts.each do |text|
          begin
            title       = compile_title(text, volume_number)
            categories  = category_tags(text)
            content     = compile_content(nil, text, volume_number, categories)
            response    = uploader.create_page(title, content)
            puts response.data
            ActionCable.server.broadcast 'alerts',
              message: "VOLUME MODEL successfully uploaded: #{title}",
              html_class: "success",
              text_decoration: "b", # bold
              page_type: "VOLUME MODEL",
              url: target_url(text.destination, response.data['pageid']),
              page_name: "#{title}"
          rescue MediawikiApi::ApiError => api_error
            puts "UPLOAD ERROR: #{api_error} (#{title})"
            ActionCable.server.broadcast 'alerts',
              message: "Uploading failed for VOLUME MODEL #{title}: #{api_error}",
              html_class: "danger",
              text_decoration: "s", # strikethrough
              page_type: "VOLUME MODEL",
              page_name: "#{title}"
          end
        end
      end
    end

    def upload_compiled_texts(volume, vol_num, uploader)
      volume.texts.each do |text|
        begin
          template    = find_template(text)
          title       = text.name
          categories  = category_tags(text)
          content     = compile_content(text, template, vol_num, categories)
          response    = uploader.create_page(title, content)
          text.update(api_response: response.data['result'])
          puts response.data
          ActionCable.server.broadcast 'alerts',
            message: "TEXT successfully uploaded: #{title}",
            html_class: "success",
            text_decoration: "b", # bold
            page_type: "TEXT",
            url: target_url(text.destination, response.data['pageid']),
            page_name: "#{title}"
        rescue MediawikiApi::ApiError => api_error
          puts "UPLOAD ERROR: #{api_error} (#{text.name}, #{text.id})"
          text.update(api_response: api_error)
          text.failed_upload!
          ActionCable.server.broadcast 'alerts',
            message: "Uploading failed for TEXT #{title}: #{api_error}",
            html_class: "danger",
            text_decoration: "s", # strikethrough
            page_type: "TEXT",
            page_name: "#{title}"
        end
      end
    end

    def upload_volume_category_page(volume, uploader)
      title = "Category:#{volume.name}"
      content = "{{VolumeCategoryPage}}"
      response = uploader.create_page(title, content)
      puts response.data
      ActionCable.server.broadcast 'alerts',
        message: "VOLUME-CATEGORY successfully uploaded: #{title}",
        html_class: "success",
        text_decoration: "b", # bold
        page_type: "VOLUME-CATEGORY",
        url: target_url(volume.destination, response.data['pageid']),
        page_name: "#{title}"
    rescue MediawikiApi::ApiError => api_error
      puts "UPLOAD ERROR: #{api_error} (#{title}, volume.id: #{volume.id})"
      ActionCable.server.broadcast 'alerts',
        message: "Uploading failed for VOLUME-CATEGORY #{title}: #{api_error}",
        html_class: "danger",
        text_decoration: "s", # strikethrough
        page_type: "VOLUME-CATEGORY",
        page_name: "#{title}"
    end

    def upload_karchag_category_page(volume, uploader)
      title = "Category:#{volume.name}-Karchag"
      content = "{{KarchagCategoryPage}}"
      response = uploader.create_page(title, content)
      puts response.data
      ActionCable.server.broadcast 'alerts',
        message: "KARCHAG-CATEGORY successfully uploaded: #{title}",
        html_class: "success",
        text_decoration: "b", # bold
        page_type: "KARCHAG-CATEGORY",
        url: target_url(volume.destination, response.data['pageid']),
        page_name: "#{title}"
    rescue MediawikiApi::ApiError => api_error
      puts "UPLOAD ERROR: #{api_error} (#{title}, volume.id: #{volume.id})"
      ActionCable.server.broadcast 'alerts',
        message: "Uploading failed for KARCHAG-CATEGORY #{title}: #{api_error}",
        html_class: "danger",
        text_decoration: "s", # strikethrough
        page_type: "KARCHAG-CATEGORY",
        page_name: "#{title}"
    end

    def upload_text_category_page(volume, uploader)
      volume.texts.each do |text|
        begin
          title     = "Category:#{text.name}"
          content   = "{{TextCategoryPage}}"
          response  = uploader.create_page(title, content)
          puts response.data
          ActionCable.server.broadcast 'alerts',
            message: "TEXT-CATEGORY successfully uploaded: #{title}",
            html_class: "success",
            text_decoration: "b", # bold
            page_type: "TEXT-CATEGORY",
            url: target_url(text.destination, response.data['pageid']),
            page_name: "#{title}"
        rescue MediawikiApi::ApiError => api_error
          puts "UPLOAD ERROR: #{api_error} (#{title}, text.id: #{text.id})"
          ActionCable.server.broadcast 'alerts',
            message: "Uploading failed for TEXT-CATEGORY #{title}: #{api_error}",
            html_class: "danger",
            text_decoration: "s", # strikethrough
            page_type: "TEXT-CATEGORY",
            page_name: "#{title}"
        end
      end
    end

    def find_template(text)
      template_name = karchag?(text) ? 'KarchagMetadataTemplate' : 'TextMetadataTemplate'
      Text.find_by(name: template_name)
    end

    def karchag?(text)
      text.name.split('-').last == 'Karchag'
    end

    def compile_title(text, vol_num)
      title = text.name
      title = replace_collection_name(title, text)
      title = replace_volume_number(title, vol_num)
      title = format_category_title(title)
      title
    end

    def compile_content(text, template, vol_num, categories=[])
      content = replace_volume_number(template.content, vol_num)
      content = text.nil? ? replace_collection_name(content, template) : replace_collection_name(content, text)
      content = replace_text_number(content, text) unless text.nil?
      content = replace_content(content, text) unless text.nil?
      content = append_categories(content, categories)
    end

    def replace_collection_name(string, text)
      coll_name = text.volume.collection.name
      string.gsub(/@@+/, coll_name)
    end

    def replace_volume_number(string, vol_num)
      string.gsub(/##+/, vol_num)
    end

    def replace_text_number(string, text)
      text_num = text.name.split('-').last
      string.gsub(/%%+/, text_num)
    end

    def format_category_title(title)
      title.gsub(/^Category-/, 'Category:')
    end

    def replace_content(template, text)
      template.gsub(/CONTENT-TO-INSERT-HERE/, text.content)
    end

    # def replace_title(string, title)
    #   string.gsub(/XXX+/, replacement)
    # end

    def append_categories(content, categories)
      # categories = clean_categories(categories)
      content += "\n" + categories.join("\n") if categories.present?
      content
    end

    def ignore_categories
      [ '', 'Models', 'Model Stubs' ]
    end

    def category_tags(text)
      # EXAMPLE: category_tag = "[[Category:VALUE]]"
      vol_name    = text.volume.name
      categories  = text.categories
      categories.insert(0, vol_name) unless ignore_categories.include? vol_name
      categories.map {|cat| "[[Category:#{cat}]]" }
    end

    def target_url(destination, pageid)
      "http://#{destination}.tsadra.org/?curid=#{pageid}"
    end

    def build_mediawiki_uploader(subdomain)
      @uploader ||= MediawikiApi::Client.new wiki_url(subdomain)
      @uploader.log_in(username, password)
      @uploader
    end

    def wiki_url(subdomain)
      "http://#{subdomain}.tsadra.org/api.php"
    end

    def username
      ENV['TSADRA_WIKI_USERNAME']
    end

    def password
      ENV['TSADRA_WIKI_PASSWORD']
    end

end
