class VolumeUploader
  include Sidekiq::Worker

  def perform(wiki, volume_number, template)
    name      = File.basename(template['file']['filename'], '.txt')
    title     = "TESTING-" + name.gsub(/#+/, volume_number)
    content   = page_content(template['file']['filepath'])
    uploader  = build_mediawiki_uploader(wiki)
    response  = uploader.create_page(title, content)
    puts response.data

    # total 100 # by default
    # at 5, "Almost done"
  end

#=================================================
  private
#=================================================

    def build_mediawiki_uploader(subdomain)
      @uploader ||= MediawikiApi::Client.new wiki_url(subdomain)
      @uploader.log_in(username, password)
      @uploader
    end

    def wiki_url(subdomain)
      "http://#{subdomain}.tsadra.org/api.php"
    end

    def page_content(file_path)
      File.open(file_path, 'rb').read
    end

    def username
      ENV['TSADRA_WIKI_USERNAME']
    end

    def password
      ENV['TSADRA_WIKI_PASSWORD']
    end

end