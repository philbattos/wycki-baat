# class TextUploader
#   include Sidekiq::Worker

#   def perform(wiki, text_id)
#     text          = Text.find(text_id)
#     title         = "TESTING_#{text.volume.name}_#{text.name}" # we may be able to remove the 'volume' variable if actual titles don't need to contain volume names
#     categories    = category_tags(text)
#     content       = page_content(text, categories)
#     uploader      = build_mediawiki_uploader(wiki)
#     response      = uploader.create_page(title, content)
#     puts response.data
#     # ActiveSupport::Notifications.instrument("text-upload.response", response: response.data)
#   end

# #=================================================
#   private
# #=================================================

#     def build_mediawiki_uploader(subdomain)
#       @uploader ||= MediawikiApi::Client.new wiki_url(subdomain)
#       @uploader.log_in(username, password)
#       @uploader
#     end

#     def wiki_url(subdomain)
#       "http://#{subdomain}.tsadra.org/api.php"
#     end

#     def page_content(text, categories=[])
#       # for most files File.open().read should work best (it retains all the line breaks);
#       # but for really large files, we should use the second option: IO.foreach().join('')
#       # => formatted_text = IO.foreach(file.tempfile)
#       # => formatted_text.map {|line| line.lstrip }.join('')
#       content = text.content
#       content += "\n" + categories.join("\n") if categories.present?
#       content
#     end

#     def category_tags(text)
#       # EXAMPLE: category_tag = "[[Category:VALUE]]"
#       categories = text.categories.insert(0, text.volume.name)
#       categories.map {|cat| "[[Category:#{cat}]]" }
#     end

#     def username
#       ENV['TSADRA_WIKI_USERNAME']
#     end

#     def password
#       ENV['TSADRA_WIKI_PASSWORD']
#     end

# end