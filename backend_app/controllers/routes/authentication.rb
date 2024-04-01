# routes/authentication.rb
# frozen_string_literal: true

module Todo
  module Routes
    class Authentication < Roda # rubocop:disable Style/Documentation
      route do |r|
        r.on 'google_login' do
          # api/auth/google
          r.get do
            client_id = ENV['GOOGLE_CLIENT_ID']
            redirect_uri = ENV['GOOGLE_REDIRECT_URI']
            scope = 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile'
            prompt = 'consent'
            access_type = 'offline'

            auth_url = "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=#{client_id}&redirect_uri=#{CGI.escape(redirect_uri)}&scope=#{CGI.escape(scope)}&prompt=#{prompt}&access_type=#{access_type}"

            puts "redirect_url: #{redirect_uri}"

            r.redirect(auth_url)
          end
        end

        r.on 'google_callback' do
          # api/auth/google_callback
          r.get do
            code = request.params['code']
            client_id = ENV['GOOGLE_CLIENT_ID']
            client_secret = ENV['GOOGLE_CLIENT_SECRET']
            redirect_uri = ENV['GOOGLE_REDIRECT_URI']
            token_uri = URI('https://oauth2.googleapis.com/token')

            # Prepare and send the request to exchange the code for tokens
            response = Net::HTTP.post_form(token_uri, {
                                             code:,
                                             client_id:,
                                             client_secret:,
                                             redirect_uri:,
                                             grant_type: 'authorization_code'
                                           })

            tokens = JSON.parse(response.body)
            refresh_token = tokens['refresh_token']
            access_token = tokens['access_token']

            user_info = SSOAuth.fetch_user_info(access_token)
            user_data = JSON.parse(user_info)

            account = Account.first(email: user_data['email'])
            if account
              account.update(
                name: user_data['name'].force_encoding('UTF-8'),
                avatar: user_data['picture'],
                access_token: user_data['access_token'],
                refresh_token: tokens['refresh_token']
              )
              jwt = JWTCredential.generate_jwt(account.attributes[:id], account.attributes[:roles])

              puts "/login?token=#{jwt}"
              r.redirect "/login?token=#{jwt}"
            else
              r.redirect '/login?error=account_not_found'
            end
          end
        end

        r.on 'verify_google_token' do
          # api/auth/verify_google_token
          r.get do
            { message: 'Auth API' }.to_json
          end
          r.post do
            request_body = JSON.parse(r.body.read)
            access_token = request_body['accessToken']
            user_info = SSOAuth.fetch_user_info(access_token)
            user_data = JSON.parse(user_info)
            # Check if the account exists
            account = Account.first(email: user_data['email'])
            if account
              account.update(
                name: user_data['name'].force_encoding('UTF-8'),
                avatar: user_data['picture'],
                access_token: user_data['access_token']
              )
              jwt = JWTCredential.generate_jwt(account.attributes[:id], account.attributes[:roles])
              account_data = account.attributes
              account_data['credential'] = jwt
              response.status = 200
              { success: true, message: 'Login successful', user_info: account_data }.to_json
            else
              response.status = 404
              { error: 'Account Not Found' }.to_json
            end
          rescue JSON::ParserError => e
            response.status = 400
            { error: 'Invalid JSON', details: e.message }.to_json
          rescue StandardError => e
            response.status = 500
            { error: 'Internal Server Error', details: e.message }.to_json
          end
        end
      end
    end
  end
end
