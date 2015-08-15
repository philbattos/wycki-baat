class Template < ActiveRecord::Base

  #-------------------------------------------------
  #    Associations
  #-------------------------------------------------

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------

  def create_page(file, wiki_url)
    uploader  = build_mediawiki_uploader(wiki_url)
    file_name = file.original_filename.rpartition('.').first
    title     = "TESTING_" + file_name
    content   = page_content(file)

    uploader.create_page(title, content)
  end

#=================================================
  private
#=================================================

    def page_content(file)
      # for most files File.open().read should work best (it retains all the line breaks);
      # but for really large files, we should use the second option: IO.foreach().join('')
      File.open(file.tempfile, 'rb').read
      # formatted_text = IO.foreach(file.tempfile)
      # formatted_text.map {|line| line.lstrip }.join('')
    end

    def build_mediawiki_uploader(wiki_url)
      client = MediawikiApi::Client.new wiki_url
      client.log_in(username, password)
      client
    end

    def username
      ENV['TERDZOD_USERNAME']
      # ENV['LIBRARY_WIKI_USERNAME']
      # current_user.terdzod_username
    end

    def password
      ENV['TERDZOD_PASSWORD']
      # ENV['LIBRARY_WIKI_PASSWORD']
      # current_user.terdzod_password
    end

end
