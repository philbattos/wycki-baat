class TemplateUploader
  include Sidekiq::Worker

  def perform(wiki)
    uploader  = build_mediawiki_uploader(wiki)
    templates = Template.all

    templates.each do |template|
      begin
        template.start_upload!
        title     = build_title(template)
        content   = template.content
        # add categories?
        response  = uploader.create_page(title, content)
        puts response.data
        ActionCable.server.broadcast 'alerts',
          message: "TEMPLATE successfully uploaded: #{title}",
          html_class: "success",
          text_decoration: "b", # bold
          page_type: "TEMPLATE",
          page_name: "#{title}"
        template.complete_upload!
      rescue MediawikiApi::ApiError => api_error
        puts "UPLOAD ERROR: #{api_error} (#{title})"
        template.update(api_response: api_error)
        template.failed_upload!
        ActionCable.server.broadcast 'alerts',
          message: "Uploading failed for TEMPLATE #{title}: #{api_error}",
          html_class: "danger",
          text_decoration: "s", # strikethrough
          page_type: "TEMPLATE",
          page_name: "#{title}"
      end
    end
    ActionCable.server.broadcast 'alerts',
      message: "Templates have finished uploading.",
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

    def build_title(template)
      template.name.gsub('-', ':') + "-TESTING"
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