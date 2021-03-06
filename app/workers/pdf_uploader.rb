require 'open-uri'

class PDFUploader
  include Sidekiq::Worker

  def perform(pdf_id)
    pdf       = PdfOriginal.find(pdf_id)
    uploader  = build_mediawiki_uploader(pdf.destination)

    begin
      title           = build_title(pdf)
      comments        = build_comments(pdf) # category tags
      ignorewarnings  = true # allows multiple uploads with same filename
      temp_file       = URI.parse(pdf.pdf_file)
      filepath        = temp_file.open

      # We're sending "comments" twice: once for the "comment" param and once for the "text" param.
      # The hope is that Mediawiki will use the "text" param to populate category tags on the wiki.
      response        = uploader.upload_image(title, filepath, "", ignorewarnings, comments)
      puts response.data
      ActionCable.server.broadcast 'alerts',
        message: "PDF successfully uploaded: #{title}",
        html_class: "success",
        text_decoration: "b", # bold
        page_type: "PDF",
        url: response.data['imageinfo']['descriptionurl'],
        page_name: "#{title}"
    rescue MediawikiApi::ApiError => api_error
      puts "UPLOAD ERROR: #{api_error} (#{title})"
      ActionCable.server.broadcast 'alerts',
        message: "Uploading failed for PDF #{title}: #{api_error}",
        html_class: "danger",
        text_decoration: "s", # strikethrough
        page_type: "PDF",
        page_name: "#{title}"
    end

    pdf.destroy
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
      filename = pdf.name
      "File:#{filename}"
    end

    def build_comments(pdf)
      category_tags = pdf.categories.map! { |category| "[[Category:#{category}]]\n" }.join('')
      category_tags += "[[Category:#{pdf.name}]]\n"
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