# frozen_string_literal: true

require 'roda'
require 'json'
require_relative '../models/account'
require_relative '../controllers/routes/account'
require_relative '../controllers/routes/authentication'

module Todo
  class Api < Roda # rubocop:disable Style/Documentation
    plugin :render
    plugin :public, root: 'dist'
    plugin :all_verbs
    plugin :halt

    include SecureRequestHelpers

    # Register the error_handler plugin
    plugin :error_handler do |e|
      case e
      when Sequel::NoMatchingRow
        response.status = 404
        { error: 'Not Found' }.to_json
      else
        response.status = 500
        { error: 'Internal Server Error', details: e.message }.to_json
      end
    end

    route do |r|
      r.public
      # Nesting todos and auth under the 'api' route
      r.on 'api' do
        # All todo-related routes are under 'api/todo'
        r.on 'todos' do
          r.run Routes::Todos # Routes::Todos is defined in 'routes/todos.rb'
        end

        # All authentication-related routes are under 'api/auth'
        r.on 'auth' do
          r.run Routes::Authentication # Routes::Authentication is defined in 'routes/authentication.rb'
        end

        # All account-related routes are under 'api/account'
        r.on 'account' do
          r.run Routes::Accounts
        end

        r.get do
          response['Content-Type'] = 'application/json'
          { success: true, message: 'Welcome to the Todo API' }.to_json
        end
      end

      r.root do
        File.read(File.join('dist', 'index.html'))
      end

      r.get String do |_parsed_request|
        File.read(File.join('dist', 'index.html'))
      end
    end
  end
end
