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
    text_files = files.select {|file| file.original_filename.slice(-4, 4) == '.txt' }
    volumes =
      text_files.group_by do |file|
        path = file.headers.match(/(filename=)("(.+)")/).captures.last
        parent, volume, *misc, text_name = path.split('/')
        volume
      end

    puts volumes.keys
    templates = volumes['templates']
    puts templates

    uploader = build_mediawiki_uploader

    volumes.each do |vol, files|
      next if vol == 'templates'
      vol_number = vol.match(/\d+/)[0]
      puts "volume number #{vol_number}"
      templates.each do |template|
        puts "uploading template #{template}"
        name  = template.original_filename.rpartition('.').first
        title = "TESTING-" + name.gsub(/#+/, vol_number)
        content   = template_content(template)
        puts title
        puts content
        response  = uploader.create_page(title, content)
      end
    end


    text_files.each do |text|
      path = text.headers.match(/(filename=)("(.+)")/).captures.last
      puts path
      parent, volume, *misc, text_name = path.split('/')
      next if volume == 'templates'
      folder_names  = misc.insert(0, volume)
      file_name     = text_name.rpartition('.').first
      title         = "TESTING_#{volume}_#{file_name}"
      categories    = category_tags(folder_names)
      content       = page_content(text, categories)
      response      = uploader.create_page(title, content)

      puts response.data
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

    def page_content(file, categories)
      # for most files File.open().read should work best (it retains all the line breaks);
      # but for really large files, we should use the second option: IO.foreach().join('')
      content = File.open(file.tempfile, 'rb').read
      content + "\n" + categories.join("\n")
      # formatted_text = IO.foreach(file.tempfile)
      # formatted_text.map {|line| line.lstrip }.join('')
    end

    def template_content(file)
      File.open(file.tempfile, 'rb').read
    end

    def category_tags(categories)
      # category_tag = "[[Category:VALUE]]"
      categories.map {|cat| "[[Category:#{cat}]]" }
    end

    def username
      ENV['TERDZOD_USERNAME']
      # ENV['LIBRARY_WIKI_USERNAME']
    end

    def password
      ENV['TERDZOD_PASSWORD']
      # ENV['LIBRARY_WIKI_PASSWORD']
    end

end
