# routes/authentication.rb
# encoding: UTF-8

module Todo
  module Routes
    class Authentication < Roda
      route do |r|
        r.on 'verify_google_token' do
          # api/auth/verify_google_token
          r.get do
            { message: 'Auth API' }.to_json
          end
          r.post do
            begin
              request_body = JSON.parse(r.body.read)
              access_token = request_body['access_token']
              user_info = SSOAuth.fetch_user_info(access_token)
              user_data = JSON.parse(user_info)

              # Check if the account exists
              account = Account.first(email: user_data['email'])

              if account
                # Account exists, respond with success
                response.status = 200
                { success: true, message: 'Login successful', user_info: account.attributes }.to_json
              else
                # Account doesn't exist, create a new one
                account = Account.create(
                  name: user_data['name'].force_encoding('UTF-8'),
                  email: user_data['email'],
                  role_id: 4,
                  sso_token: access_token
                )
                response.status = 201
                { success: true, message: 'Account created', user_info: account.attributes }.to_json
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
end
