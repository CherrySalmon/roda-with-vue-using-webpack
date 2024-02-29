# routes/authentication.rb
# frozen_string_literal: true

module Todo
  module Routes
    class Authentication < Roda # rubocop:disable Style/Documentation
      route do |r|
        r.on 'verify_google_token' do
          # api/auth/verify_google_token
          r.get do
            { message: 'Auth API' }.to_json
          end
          r.post do
            request_body = JSON.parse(r.body.read)
            # sso_token = request_body['sso_token']
            # user_info = SSOAuth.fetch_user_info(sso_token)
            # user_data = JSON.parse(user_info)
            user_data = request_body['user_data']
            # Check if the account exists
            account = Account.first(email: user_data['email'])
            if account
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
