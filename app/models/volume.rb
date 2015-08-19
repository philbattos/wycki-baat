class Volume < ActiveRecord::Base

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------


  def create_pages(files)
    uploader = build_mediawiki_uploader

    files.each do |file|
      file_name = file.original_filename.rpartition('.').first
      title     = "TESTING_" + file_name
      content   = page_content(file)
      response  = uploader.create_page(title, content)
      # puts response.body
      puts response.data
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

end
