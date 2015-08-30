class Portal < ActiveRecord::Base
  # responsible for connecting research.tsadra.org with librarywiki.tsadra.org

  def fetch(query)
    # test_query  = 'https://research.tsadra.org/index.php?title=Special%3AAsk&q=%5B%5BBuddhism%2C+Sexuality%2C+and+Gender%5D%5D&po=author%0D%0Afulltitle%0D%0Apublisher%0D%0A&eq=yes&p%5Bformat%5D=csv&p%5Bsep%5D=%2C'
    uri         = build_uri(query)
    digest_auth = Net::HTTP::DigestAuth.new
    response    = authenticate_request(uri, digest_auth)
    response.body
  end

#=================================================
  private
#=================================================

    def build_uri(query)
      wiki          = 'https://research.tsadra.org/index.php?'
      wiki_query    = wiki + query
      uri           = URI(wiki_query)
      uri.user      = ENV['RESEARCH_WIKI_FIREWALL_USERNAME']
      uri.password  = ENV['RESEARCH_WIKI_FIREWALL_PASSWORD']
      uri
    end

    def authenticate_request(uri, digest_auth)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request1        = Net::HTTP::Get.new uri            # initial request
        response1       = http.request request1             # initial response from remote server
        authentication  = digest_auth.auth_header uri, response1['www-authenticate'], 'GET'
        request2        = Net::HTTP::Get.new uri            # prepare follow-up request
        request2.add_field 'Authorization', authentication  # add hashed authentication to follow-up request
        http.request request2                               # final request & response
      end
    end

end