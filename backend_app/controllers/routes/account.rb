# routes/account.rb

require 'json'

module Todo
  module Routes
    class Accounts < Roda
      plugin :all_verbs
      route do |r|
        r.on do
          r.get do
            # List all accounts with name, email, account name
            accounts = Account.all.map do |account|
              account.attributes
            end
            response.status = 200
            { success: true, data: accounts }.to_json
          end
          r.post do
            begin
              request_body = JSON.parse(r.body.read)
              user_data = request_body['user_data']
              account = Account.add_account(
                {
                  name: user_data['name'].force_encoding('UTF-8'),
                  email: user_data['email'],
                  roles: user_data['roles'],
                  sso_token: user_data['sso_token']
                }
              )
              response.status = 201
              { success: true, message: 'Account created', user_info: account.attributes }.to_json
            rescue JSON::ParserError => e
              response.status = 400
              { error: 'Fail to create account', details: e.message }.to_json
            end
          end
          r.put String do |target_id|
            request_body = JSON.parse(r.body.read)
            user_data = request_body['user_data']
            begin
              account = Account.update_account(target_id, user_data)
              if account
                response.status = 200
                { success: true, message: 'Account updated' }.to_json
              else
                response.status = 404
                { error: 'Account not found' }.to_json
              end
            rescue JSON::ParserError => e
              response.status = 400
              { error: 'Invalid JSON', details: e.message }.to_json
            end
          end

          r.delete String do |target_id|
            request_body = JSON.parse(r.body.read)
            user_data = request_body['user_data']

            begin
              account = Account.first(id: target_id)
              if account
                account.delete
                response.status = 200
                { success: true, message: 'User deleted' }.to_json
              else
                response.status = 404
                { error: 'User not found' }.to_json
              end
            rescue JSON::ParserError => e
              response.status = 400
              { error: 'Invalid JSON', details: e.message }.to_json
            end
          end
        end
      end
    end
  end
end
