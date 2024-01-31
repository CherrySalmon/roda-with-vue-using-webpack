# routes/account.rb

require 'json'

module Todo
  module Routes
    class Accounts < Roda
      plugin :all_verbs
      route do |r|
        r.on do
          r.get do
            { message: 'Account API' }.to_json
          end
          r.post do
            request_body = JSON.parse(r.body.read)
            account_id = request_body['account_id']
            if Authorization.permission(account_id, 'accounts:view')
              # List all accounts with name, email, account name
              accounts = Account.all.map do |account|
                account.to_hash_with_role
              end
              response.status = 200
              { success: true, data: accounts }.to_json
            else
              response.status = 403
              { error: 'Forbidden' }.to_json
            end
          end
          r.put String do |target_id|
            request_body = JSON.parse(r.body.read)
            account_id = request_body['account_id']

            if Authorization.permission(account_id, 'accounts:modify')
              begin
                new_role_id = Role.get_id_by_name(request_body['role'])
                new_email = request_body['email']

                account = Account.first(id: target_id)
                if account
                  account.update(role_id: new_role_id, email: new_email)
                  response.status = 200
                  { success: true, message: 'User updated' }.to_json
                else
                  response.status = 404
                  { error: 'User not found' }.to_json
                end
              rescue JSON::ParserError => e
                response.status = 400
                { error: 'Invalid JSON', details: e.message }.to_json
              end
            else
              response.status = 403
              { error: 'Forbidden' }.to_json
            end
          end

          r.delete String do |target_id|
            # request_body = JSON.parse(r.body.read)
            # account_id = request_body['account_id']
            account_id = 1
            if Authorization.permission(account_id, 'accounts:modify')
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
            else
              response.status = 403
              { error: 'Forbidden' }.to_json
            end
          end
        end
      end
    end
  end
end
