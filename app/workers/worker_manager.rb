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
      upload_texts(vol, uploader)
      vol.complete_upload!
    end
    ActionCable.server.broadcast 'alerts',
      message: "Volumes & Texts uploading finished.",
      html_class: "info"
  end

#=================================================
  private
#=================================================

    def upload_templates(volume_number, uploader)
      volume_templates = Volume.templates # we're assuming that all template files are less than 2mb in size
      volume_templates.each do |volume|
        volume.texts.each do |text|
          begin
            # VolumeUploader.perform_async(wiki, volume_number, text.id)
            title     = "TESTING-" + text.name.gsub(/#+/, volume_number)
            content   = text.content
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

    def upload_texts(volume, uploader)
      volume.texts.each do |text|
        begin
          # TextUploader.perform_async(wiki, text.id)
          title         = "TESTING_#{volume.name}_#{text.name}" # we may be able to remove the 'volume' variable if actual titles don't need to contain volume names
          categories    = category_tags(text)
          content       = page_content(text, categories)
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
