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
            prompt = 'login'
            access_type = 'offline'

            auth_url = "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=#{client_id}&redirect_uri=#{CGI.escape(redirect_uri)}&scope=#{CGI.escape(scope)}&prompt=#{prompt}&access_type=#{access_type}"

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

              roles_name = account.roles.map{|role| role.name}
              r.redirect "/login?credential=#{jwt}&name=#{account.name}&id=#{account.id}&avatar=#{account.avatar}&roles=#{roles_name.join(',')}"
            else
              r.redirect '/login?error=account_not_found'
            end
          end
        end
      end
    end
  end
end
