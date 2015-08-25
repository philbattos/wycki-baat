class Text < ActiveRecord::Base
  after_initialize :build_mediawiki_uploader

  #-------------------------------------------------
  #    Validations
  #-------------------------------------------------

  def create_pages(files)
    # This selects all the text files in all the folders that were selected. It basically means
    # loading all of the files into memory. That could require A LOT of memory for large collections.

    volumes   = format_volumes(files)
    templates = volumes['templates']
    volumes.delete('templates')

    volumes.each do |vol, files|
      # create batching??
      vol_num = vol.match(/\d+/)[0]
      upload_templates(vol_num, templates)
      upload_texts(vol, vol_num, files)
    end
  end

#=================================================
  private
#=================================================

    def build_mediawiki_uploader
      @uploader ||= MediawikiApi::Client.new wiki_url
      @uploader.log_in(username, password)
      @uploader
    end

    def wiki_url
      "http://#{destination}.tsadra.org/api.php"
    end

    def format_volumes(files)
      text_files  = files.select {|file| File.extname(file.path) == '.txt' }
      volumes     = Hash.new{|h,k| h[k] = []}
      text_files.each do |file|
        path = file.headers.match(/(filename=)("(.+)")/).captures.last
        root, volume, *misc, text_name = path.split('/') # EXAMPLE: wikipages/volume1/*/text-name
        volumes[volume] << { path: path, categories: misc, file: file }
      end
      volumes
    end

    def upload_templates(volume_number, templates)
      templates.each do |template|
        name      = File.basename(template[:file].original_filename, '.txt')
        title     = "TESTING-" + name.gsub(/#+/, volume_number)
        file_path = template[:file].tempfile
        content   = page_content(file_path)
        response  = @uploader.create_page(title, content)
        puts response.data
      end
    end

    def upload_texts(volume, vol_num, texts)
      texts.each do |text|
        folder_names  = text[:categories].insert(0, volume)
        file_name     = File.basename(text[:file].original_filename, '.txt')
        file_path     = text[:file].tempfile
        title         = "TESTING_#{volume}_#{file_name}" # we may be able to remove the 'volume' variable if actual titles don't need to contain volume names
        categories    = category_tags(folder_names)
        content       = page_content(file_path, categories)
        response      = @uploader.create_page(title, content)
        puts response.data
      end
    end

    def page_content(file_path, categories=[])
      # for most files File.open().read should work best (it retains all the line breaks);
      # but for really large files, we should use the second option: IO.foreach().join('')
      # => formatted_text = IO.foreach(file.tempfile)
      # => formatted_text.map {|line| line.lstrip }.join('')
      content = File.open(file_path, 'rb').read
      content += "\n" + categories.join("\n") if categories.present?
      content
    end

    def category_tags(categories)
      # EXAMPLE: category_tag = "[[Category:VALUE]]"
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
