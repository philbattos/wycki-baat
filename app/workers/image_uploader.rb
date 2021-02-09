require 'open-uri'

class ImageUploader
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(image_id)
    image     = Image.find(image_id)
    uploader  = build_mediawiki_uploader(image.destination)

    begin
      title           = build_title(image)
      comments        = build_comments(image) # category tags
      ignorewarnings  = true                  # allows multiple uploads with same filename
      temp_file       = URI.parse(image.image_file)
      filepath        = temp_file.open
      response        = uploader.upload_image title, filepath, comments, ignorewarnings
      puts response.data
      ActionCable.server.broadcast 'alerts',
        message: "Image successfully uploaded: #{title}",
        html_class: "success",
        text_decoration: "b", # bold
        page_type: "IMAGE",
        url: response.data['imageinfo']['descriptionurl'],
        page_name: "#{title}"
    rescue URI::InvalidURIError => error
      puts "UPLOAD ERROR: #{error} (#{title})"
      ActionCable.server.broadcast 'alerts',
        message: "Uploading failed for IMAGE #{title}: #{error}",
        html_class: "danger",
        text_decoration: "s", # strikethrough
        page_type: "IMAGE",
        page_name: "#{title}"
    rescue MediawikiApi::ApiError => api_error
      puts "UPLOAD ERROR: #{api_error} (#{title})"
      ActionCable.server.broadcast 'alerts',
        message: "Uploading failed for IMAGE #{title}: #{api_error}",
        html_class: "danger",
        text_decoration: "s", # strikethrough
        page_type: "IMAGE",
        page_name: "#{title}"
    rescue StandardError => error
      puts "UPLOAD ERROR: #{error} (#{title})"
      ActionCable.server.broadcast 'alerts',
        message: "Uploading failed for IMAGE #{title}: #{error}",
        html_class: "danger",
        text_decoration: "s", # strikethrough
        page_type: "IMAGE",
        page_name: "#{title}"
    end

    image.destroy
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
      filename = image.name
      "File:#{filename}"
    end

    def build_comments(image)
      image.categories.map! { |category| "[[Category:#{category}]]\n" }.join('')
    end

    def wiki_url(subdomain)
      "https://#{subdomain}.tsadra.org/api.php"
    end

    def username
      ENV['TSADRA_WIKI_USERNAME']
    end

    def password
      ENV['TSADRA_WIKI_PASSWORD']
    end

end