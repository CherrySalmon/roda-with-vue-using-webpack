require 'net/http'
require 'json'

module Todo
  class SSOAuth
    def self.fetch_user_info(access_token)
      uri = URI('https://www.googleapis.com/oauth2/v3/userinfo')
      uri.query = URI.encode_www_form(access_token:)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        response.body
      else
        puts "Error fetching user info: #{response.code} #{response.message}"
        { error: 'Failed to fetch user info' }.to_json
      end
    end
  end
end
