# class VolumeUploader
#   include Sidekiq::Worker

#   def perform(wiki, volume_number, text_id)
#     template  = Text.find(text_id)
#     title     = "TESTING-" + template.name.gsub(/#+/, volume_number)
#     content   = template.content
#     uploader  = build_mediawiki_uploader(wiki)
#     response  = uploader.create_page(title, content)
#     puts response.data
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

#     def username
#       ENV['TSADRA_WIKI_USERNAME']
#     end

#     def password
#       ENV['TSADRA_WIKI_PASSWORD']
#     end

# end