require 'open-uri'

class PDFUploader
  include Sidekiq::Worker

  def perform(pdf_id)
    pdf       = PdfOriginal.find(pdf_id)
    uploader  = build_mediawiki_uploader(pdf.destination)

    begin
      title           = build_title(pdf)
      # comments        = build_comments(pdf) # category tags
      ignorewarnings  = true # allows multiple uploads with same filename
      temp_file       = URI.parse(pdf.pdf_file)
      filepath        = temp_file.open
      response        = uploader.upload_image title, filepath, 'testing-pdfs', ignorewarnings
      puts response.data
      ActionCable.server.broadcast 'alerts',
        message: "PDF successfully uploaded: #{title}",
        html_class: "success",
        text_decoration: "b", # bold
        page_type: "PDF",
        url: response.data['imageinfo']['descriptionurl'],
        page_name: "#{title}"
      # File.delete(pdf)
    rescue MediawikiApi::ApiError => api_error
      puts "UPLOAD ERROR: #{api_error} (#{title})"
      ActionCable.server.broadcast 'alerts',
        message: "Uploading failed for PDF #{title}: #{api_error}",
        html_class: "danger",
        text_decoration: "s", # strikethrough
        page_type: "PDF",
        page_name: "#{title}"
    end
    # if PdfOriginal.all.count == PdfOriginal.uploaded.count
    #   ActionCable.server.broadcast 'alerts',
    #     message: "PDFs have finished uploading.",
    #     html_class: "info"
    # end
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
      # filename = pdf.pdf_file_identifier
      filename = pdf.name
      "File:#{filename}"
    end

    def build_comments(pdf)
      path = pdf.split('public/uploads/pdfs/').last
      collection, *categories, file = path.split('/')
      filename = File.basename(file, '.pdf')
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