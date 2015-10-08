class PDFUploader
  include Sidekiq::Worker

  def perform(wiki)
    uploader  = build_mediawiki_uploader(wiki)
    pdfs      = Dir['public/uploads/pdfs/*.pdf']

    pdfs.each do |pdf|
      begin
        # template.start_upload!
        title     = build_title(pdf)
        # content   = File.foreach(pdf).to_a.join('')
        content   = 'TEST CONTENT'
        # add categories?
        response  = uploader.create_page(title, content)
        # response  = uploader.action :upload, filename: title, file: content
        puts response.data
        ActionCable.server.broadcast 'alerts',
          message: "PDF successfully uploaded: #{title}",
          html_class: "success",
          text_decoration: "b", # bold
          page_type: "PDF",
          page_name: "#{title}"
        # template.complete_upload!
      rescue MediawikiApi::ApiError => api_error
        # puts "UPLOAD ERROR: #{api_error} (#{title})"
        # pdf.update(api_response: api_error)
        # pdf.failed_upload!
        # ActionCable.server.broadcast 'alerts',
        #   message: "Uploading failed for PDF #{title}: #{api_error}",
        #   html_class: "danger",
        #   text_decoration: "s", # strikethrough
        #   page_type: "PDF",
        #   page_name: "#{title}"
      end
    end
    ActionCable.server.broadcast 'alerts',
      message: "PDFs have finished uploading.",
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

    def build_title(pdf)
      filename = File.basename(pdf)
      "File:#{filename}-TESTING"
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