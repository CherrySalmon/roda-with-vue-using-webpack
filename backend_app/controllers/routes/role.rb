# routes/role.rb

require 'json'

module Todo
  module Routes
    class Role < Roda
      route do |r|
        # request_body = JSON.parse(r.body.read)
        # user_id = request_body['user_id']
        user_id = 1

        r.on 'users' do
          r.get do
            if Authorization.permission(user_id, 'accounts:view')
              # List all accounts with name, email, role name
              accounts = Account.all.map do |account|
                account.to_hash_with_role
              end
              response.status = 200
              { success: true, users: accounts }.to_json
            else
              response.status = 403
              { error: 'Forbidden' }.to_json
            end
          end

          r.put do
            if Authorization.permission(user_id, 'accounts:modify')
              begin
                new_role_id = request_body['role_id']
                new_email = request_body['email']

                account = Account.first(id: user_id)
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

          r.delete do
            if Authorization.permission(user_id, 'accounts:modify')
              begin
                account = Account.first(id: user_id)
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
