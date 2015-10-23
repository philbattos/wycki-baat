class PDFUploader
  include Sidekiq::Worker

  def perform(wiki, count)
    retries = 0
    begin
      puts "retries: #{retries}"
      puts "PDF-count: #{PdfOriginal.count}"
      if count == PdfOriginal.count
        send_pdfs_to_wiki(wiki)
        retries = 21
      elsif retries == 20
        raise 'All retries completed; PDFs took too long to save to AWS'
      else
        retries += 1
        sleep 5
      end
    rescue => e
      puts e
      e
    end while retries < 21
  end

  def send_pdfs_to_wiki(wiki)
    uploader      = build_mediawiki_uploader(wiki)
    uploaded_pdfs = PdfOriginal.all
    uploaded_pdfs.each do |pdf|
      puts "pdf url: #{pdf.pdf_file.url}"
      begin
        title           = build_title(pdf)
        # comments        = build_comments(pdf) # category tags
        ignorewarnings  = true # allows multiple uploads with same filename
        temp_file       = URI.parse(pdf.pdf_file.url)
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
      filename = pdf.pdf_file_identifier
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