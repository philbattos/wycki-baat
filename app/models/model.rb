class Model < ActiveRecord::Base

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------

  # def create_page(file)
  #   uploader  = build_mediawiki_uploader
  #   file_name = file.original_filename.rpartition('.').first
  #   title     = "TESTING_" + file_name
  #   content   = page_content(file)

  #   uploader.create_page(title, content)
  # end

  def create_pages(files)
    uploader = build_mediawiki_uploader

    files.each do |file|
      file_name = file.original_filename.rpartition('.').first
      title     = "TESTING_" + file_name
      content   = page_content(file)
      response  = uploader.create_page(title, content)
      puts response.data
      # puts response.body
      # puts response.status
      # puts response.inspect
      # puts success_message if response.status == '200'
    end
  end

#=================================================
  private
#=================================================

    def build_mediawiki_uploader
      client = MediawikiApi::Client.new wiki_url
      client.log_in(username, password)
      client
    end

    def wiki_url
      "http://#{destination}.tsadra.org/api.php"
    end

    def page_content(file)
      # for most files File.open().read should work best (it retains all the line breaks);
      # but for really large files, we should use the second option: IO.foreach().join('')
      File.open(file.tempfile, 'rb').read
      # formatted_text = IO.foreach(file.tempfile)
      # formatted_text.map {|line| line.lstrip }.join('')
    end

    def username
      ENV['TSADRA_WIKI_USERNAME']
    end

    def password
      ENV['TSADRA_WIKI_PASSWORD']
    end

end
