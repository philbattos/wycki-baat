class WikiBot < ActiveRecord::Base

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
    if files.nil? && look_in_dropbox?
      files = find_dropbox_files
    end

    uploader = build_mediawiki_uploader

    files.each do |file| # for thousands of files, we probably want to do batching
      title       = extract_page_title(file)
      content     = assemble_wiki_content(file, title)
      upload(title, content, uploader)
    end
  end

  def assemble_wiki_content(file, title)
    vol_num, text_num = extract_file_data(file, title)

    insert_header(vol_num, text_num) +
    tibetan_section +
    page_content(file) +
    closing_div +
    insert_footer
  end

  def extract_file_data(file, title)
    vol_folder  = file.split('/')[-2]
    vol_num     = vol_folder.split('-').first
    file_num    = title.split('-').third
    text_num    = convert_to_digit(file_num)

    [vol_num, text_num]
  end

  def convert_to_digit(file_num)
    if file_num.nil?
      ''
    else
      clean_num = file_num.match(/\A(0*)(\d+)\z/)
      clean_num.nil? ? '' : clean_num.captures.last
    end
  end

  def page_content(file)
    formatted_text = IO.foreach(file)
    formatted_text.map {|line| line.lstrip }.join('')
  end

  def insert_footer
    saved_footer || generic_footer
  end

  def saved_footer
    # footer
  end

  def generic_footer
"\n= Tsagli =
TSAGLI image gallery goes here
<headertabs/>
== Footnotes ==
<references/>
</onlyinclude>
==Other Information==
{{Footer}}
\n"
  end

  def closing_div
"\n</div>\n"
  end

  def tibetan_section
    saved_tibetan_section || generic_tibetan_section
  end

  def saved_tibetan_section
    # tibetan_html
  end

  def generic_tibetan_section
"\n<onlyinclude>
= Tibetan Text =
<div id='tibetan' class='tib-text'>\n"
  end

  def insert_header(vol_num, text_num)
    saved_header(vol_num, text_num) || generic_header(vol_num, text_num)
  end

  def saved_header(vol_num, text_num)
    # header
  end

  def generic_header(vol_num, text_num)
"{{UnderConstruction}}
{{RTZ Metadata
|classification=Tibetan Publications
|subclass = Tibetan Texts
|collectiontitle=Rin chen gter mdzod; Rin chen gter mdzod Shechen Edition
|collectiontitletib=རིན་ཆེན་གཏེར་མཛོད་
|totalvolumes=70
|compilertib=འཇམ་མགོན་ཀོང་སྤྲུལ་
|compiler='jam mgon kong sprul
|tibgenre=Revelations - gter ma
|terma=Yes
|language = Tibetan
|pagestatus=Temporary stub only
|volumenumber= #{vol_num}
|textnuminvol= #{text_num}
}}{{Header}}\n"
    # volumenumber is the number in the file's parent folder: 01, 02, 03... 70
    # textnuminvol is the number in the file name: 001, 002, 003... 100
  end

  def extract_page_title(file)
    file.split('/').last.chomp(file_extension).gsub(' ', '-')
  end

  def look_in_dropbox?
    # params[:look_in_dropbox]
    true
  end

  def find_dropbox_files
    dropbox_folder  = ENV['TERDZOD_DROPBOX_FOLDER'] # main folder that contains all source folders & files
    home_directory  = Dir.home
    source_folder   = "#{home_directory}/Dropbox/#{dropbox_folder}"
    text_files      = Dir.glob("#{source_folder}/**/*#{file_extension}") # find all the files in the dropbox folder(s) that match the file_type
    # alternative: text_files = File.fnmatch()
  end

  def file_extension
    # params[:file_extension]
    @file_type ||= ENV['TERDZOD_FILE_TYPE'] # => .txt, .pdf, .rtf,...
  end

  def build_mediawiki_uploader
    client = MediawikiApi::Client.new api_endpoint
    client.log_in(username, password)
    client
  end

  def upload(title, content, uploader)
    response = uploader.create_page(title, content)
    puts response.warnings
    response.data
  end

  # def mediawiki_create_page(title, content)
  #   client = build_mediawiki_client
  #   client.log_in(username, password)
  #   response = client.create_page(title, content)
  #   puts response.warnings
  #   response.data
  # end

  # def self.mediawiki_delete_page(title, reason)
  #   client = build_mediawiki_client
  #   client.log_in(username, password)
  #   response = client.delete_page(title, reason)
  #   puts response.warnings
  #   response.data
  # end

  # def self.mediawiki_query_page(titles)
  #   client = build_mediawiki_client
  #   # client.log_in(username, password)
  #   response = client.query titles: titles
  #   puts response.warnings
  #   response
  # end

  # def self.mediawiki_get_text(title)
  #   client = build_mediawiki_client
  #   # client.log_in(username, password)
  #   client.get_wikitext title
  # end

#=================================================
  private
#=================================================

    def username
      ENV['TERDZOD_USERNAME']
      # current_user.terdzod_username
    end

    def password
      ENV['TERDZOD_PASSWORD']
      # current_user.terdzod_password
    end

    # def self.test_request_to_media_wiki
    #   # response = RestClient.get(url) # this is slow; need to convert to IPV4
    #   uri = URI.parse(url)
    #   json_format = "?format=json"
    #   response = Net::HTTP.get_response(uri)
    #   puts response
    # end

end


#-------------------------------------------------
#    command line tool to convert all .rtf files to plain text
#-------------------------------------------------
# textutil -convert txt Dropbox/WikiBotWorkwithPhil/**/*.rtf
# source: http://osxdaily.com/2011/07/06/convert-a-text-file-to-rtf-html-doc-and-more-via-command-line/