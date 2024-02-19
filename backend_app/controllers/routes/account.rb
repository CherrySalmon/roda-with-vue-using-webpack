# routes/account.rb

require 'json'

module Todo
  module Routes
    class Accounts < Roda # rubocop:disable Style/Documentation
      plugin :all_verbs
      plugin :request_headers
      route do |r| # rubocop:disable Metrics/BlockLength
        r.on do # rubocop:disable Metrics/BlockLength
          auth_header = r.headers['Authorization']
          requestor = JWTCredential.decode_jwt(auth_header)

          # GET api/account
          r.get do
            accounts = AccountService.list_all(requestor)
            response.status = 200
            { success: true, data: accounts }.to_json
          rescue AccountService::ForbiddenError => e
            response.status = 403
            { error: 'Forbidden', details: e.message }.to_json
          end

          # POST api/account
          r.post do
            request_body = JSON.parse(r.body.read)
            account = AccountService.create(requestor, request_body)
            response.status = 201
            { success: true, message: 'Account created', user_info: account.attributes }.to_json
          rescue JSON::ParserError => e
            response.status = 400
            { error: 'Fail to create account', details: e.message }.to_json
          rescue AccountService::ForbiddenError => e
            response.status = 403
            { error: 'Forbidden', details: e.message }.to_json
          end

          # PUT api/account/:id
          r.put String do |target_id|
            request_body = JSON.parse(r.body.read)
            AccountService.update(requestor, target_id, request_body)
            response.status = 200
            { success: true, message: 'Account updated'}.to_json
          rescue AccountService::AccountNotFoundError => e
            response.status = 404
            { error: 'Forbidden', details: e.message }.to_json
          rescue AccountService::ForbiddenError => e
            response.status = 403
            { error: 'Forbidden', details: e.message }.to_json
          end

          # DELETE api/account/:id
          r.delete String do |target_id|
            AccountService.remove(requestor, target_id)
            response.status = 200
            { success: true, message: 'User deleted' }.to_json
          rescue AccountService::ForbiddenError => e
            response.status = 403 # Forbidden status code
            { error: 'Forbidden', details: e.message }.to_json
          rescue JSON::ParserError => e
            response.status = 400
            { error: 'Invalid JSON', details: e.message }.to_json
          rescue Sequel::NoMatchingRow => e # Catch if Account.first(id: target_id) returns nil
            response.status = 404
            { error: 'User not found', details: e.message }.to_json
          end
        rescue JWTCredential::ArgumentError => e
          # Handle missing token or decoding issues
          response.status = 400 # Bad Request for missing token or invalid format
          response.write({ error: 'Token error', details: e.message }.to_json)
          r.halt # Stop further processing of the request
        rescue => e
          # Handle any other unexpected errors
          response.status = 500 # Internal Server Error for unforeseen issues
          response.write({ error: 'Internal server error', details: e.message }.to_json)
          r.halt
        end
      end
    end
  end
end
