class WorkerManager
  include Sidekiq::Worker

  def perform(wiki)
    uploader  = build_mediawiki_uploader(wiki)
    volumes   = Volume.volume_pages

    volumes.each do |vol|
      vol.start_upload!
      # create batching??
      collection, *label, number = vol.name.split('-')
      # verify collection name??
      upload_templates(number, uploader)
      upload_compiled_texts(vol, number, uploader)
      # upload_texts(vol, uploader)
      vol.complete_upload!
    end
    ActionCable.server.broadcast 'alerts',
      message: "Volumes & Texts have finished uploading.",
      html_class: "info"
  end

#=================================================
  private
#=================================================

    def upload_templates(volume_number, uploader)
      volume_templates = Volume.volume_templates # we're assuming that all templates are less than 2mb in size
      volume_templates.each do |volume|
        volume.texts.each do |text|
          begin
            title     = compile_title(text, volume_number)
            content   = compile_content(nil, text, volume_number)
            response  = uploader.create_page(title, content)
            puts response.data
            ActionCable.server.broadcast 'alerts',
              message: "VOLUME TEMPLATE successfully uploaded: #{title}",
              html_class: "success",
              text_decoration: "b", # bold
              page_type: "VOLUME TEMPLATE",
              page_name: "#{title}"
          rescue MediawikiApi::ApiError => api_error
            puts "UPLOAD ERROR: #{api_error} (#{title})"
            ActionCable.server.broadcast 'alerts',
              message: "Uploading failed for VOLUME TEMPLATE #{title}: #{api_error}",
              html_class: "danger",
              text_decoration: "s", # strikethrough
              page_type: "VOLUME TEMPLATE",
              page_name: "#{title}"
          end
        end
      end
    end

    def upload_compiled_texts(volume, vol_num, uploader)
      volume.texts.each do |text|
        begin
          template      = find_template(text)
          title         = "TESTING_#{text.name}"
          content       = compile_content(text, template, vol_num)
          response      = uploader.create_page(title, content)
          text.update(api_response: response.data['result'])
          text.successful_upload!
          puts response.data
          ActionCable.server.broadcast 'alerts',
            message: "TEXT successfully uploaded: #{title}",
            html_class: "success",
            text_decoration: "b", # bold
            page_type: "TEXT",
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

    # def upload_texts(volume, uploader)
    #   volume.texts.each do |text|
    #     begin
    #       title         = "TESTING_#{volume.name}_#{text.name}" # we may be able to remove the 'volume' variable if actual titles don't need to contain volume names
    #       categories    = category_tags(text)
    #       content       = page_content(text, categories)
    #       response      = uploader.create_page(title, content)
    #       text.update(api_response: response.data['result'])
    #       text.successful_upload!
    #       puts response.data
    #       ActionCable.server.broadcast 'alerts',
    #         message: "TEXT successfully uploaded: #{title}",
    #         html_class: "success",
    #         text_decoration: "b", # bold
    #         page_type: "TEXT",
    #         page_name: "#{title}"
    #     rescue MediawikiApi::ApiError => api_error
    #       puts "UPLOAD ERROR: #{api_error} (#{text.name}, #{text.id})"
    #       text.update(api_response: api_error)
    #       text.failed_upload!
    #       ActionCable.server.broadcast 'alerts',
    #         message: "Uploading failed for TEXT #{title}: #{api_error}",
    #         html_class: "danger",
    #         text_decoration: "s", # strikethrough
    #         page_type: "TEXT",
    #         page_name: "#{title}"
    #     end
    #   end
    # end

    def find_template(text)
      template_name = karchag?(text) ? 'KarchagMetadataTemplate' : 'TextMetadataTemplate'
      Text.find_by(name: template_name)
    end

    def karchag?(text)
      text.name.split('-').last == 'Karchag'
    end

    def compile_title(text, vol_num)
      "TESTING-" + replace_volume_number(text.name, vol_num)
    end

    def compile_content(text, template, vol_num)
      content = replace_volume_number(template.content, vol_num)
      text.nil? ? content : replace_content(content, text)
    end

    def replace_volume_number(string, vol_num)
      string.gsub(/##+/, vol_num)
    end

    def replace_content(template, text)
      template.gsub(/CONTENT-TO-INSERT-HERE/, text.content)
    end

    # def replace_title(string, title)
    #   string.gsub(/XXX+/, replacement)
    # end

    def page_content(text, categories=[])
      # for most files File.open().read should work best (it retains all the line breaks);
      # but for really large files, we should use the second option: IO.foreach().join('')
      # => formatted_text = IO.foreach(file.tempfile)
      # => formatted_text.map {|line| line.lstrip }.join('')
      content = text.content
      content += "\n" + categories.join("\n") if categories.present?
      content
    end

    def category_tags(text)
      # EXAMPLE: category_tag = "[[Category:VALUE]]"
      categories = text.categories.insert(0, text.volume.name)
      categories.map {|cat| "[[Category:#{cat}]]" }
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
