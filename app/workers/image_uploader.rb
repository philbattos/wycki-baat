class ImageUploader
  include Sidekiq::Worker

  def perform(wiki)
    uploader  = build_mediawiki_uploader(wiki)
    images    = Dir['public/uploads/images/**/*.*']

    images.each do |image|
      begin
        title           = build_title(image)
        comments        = build_comments(image) # category tags
        ignorewarnings  = true # allows multiple uploads with same filename
        response        = uploader.upload_image title, image, comments, ignorewarnings
        puts response.data
        ActionCable.server.broadcast 'alerts',
          message: "IMAGE successfully uploaded: #{title}",
          html_class: "success",
          text_decoration: "b", # bold
          page_type: "IMAGE",
          url: response.data['imageinfo']['descriptionurl'],
          page_name: "#{title}"
        File.delete(image)
      rescue MediawikiApi::ApiError => api_error
        puts "UPLOAD ERROR: #{api_error} (#{title})"
        ActionCable.server.broadcast 'alerts',
          message: "Uploading failed for IMAGE #{title}: #{api_error}",
          html_class: "danger",
          text_decoration: "s", # strikethrough
          page_type: "IMAGE",
          page_name: "#{title}"
      end
    end
    ActionCable.server.broadcast 'alerts',
      message: "Images have finished uploading.",
      html_class: "info"
  end

#=================================================
  private
#=================================================

    def build_mediawiki_uploader(subdomain)
      @uploader ||= MediawikiApi::Client.new wiki_url(subdomain)
      @uploader.log_in(username, password)
      @uploader
    end

    def build_title(image)
      filename = File.basename(image)
      "File:#{filename}"
    end

    def build_comments(image)
      path = image.split('public/uploads/images/').last
      collection, *categories, file = path.split('/')
      filename = File.basename(file, '.*')
      category_tags = categories.map! { |category| "[[Category:#{category}]]\n" }.join('')
      category_tags + "[[Category:#{filename}]]\n"
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