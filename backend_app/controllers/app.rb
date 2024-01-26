# frozen_string_literal: true

require 'roda'
require 'json'

module Todo
  # Backend web app controller
  class App < Roda
    # app using
    plugin :render
    plugin :public, root: 'dist'

    # api using
    plugin :all_verbs
    plugin :halt

    # rubocop:disable Metrics/BlockLength
    route do |r|
      r.public

      # api part
      r.on 'todos' do
        r.post do
          data = JSON.parse(r.body.read)
          todo = Todo.create(data)
          response.status = 201
          todo.to_json
        end

        r.get String do |todo_id|
          response['Content-Type'] = 'application/json'
          output = { data: Todo.first(id: todo_id) }
          response.status = 200
          JSON.pretty_generate(output)
        end

        r.get do
          response['Content-Type'] = 'application/json'
          output = { data: Todo.all }
          response.status = 200
          JSON.pretty_generate(output)
        end

        r.delete String do |id|
          Todo.where(id:).delete
          response['Content-Type'] = 'application/json'
          response.status = 200
          JSON.pretty_generate({ success: true, message: 'delete the todo' })
        rescue StandardError
          r.halt 500, { message: 'Database error' }.to_json
        end
      end

      r.get 'api' do
        response['Content-Type'] = 'application/json'
        JSON.generate({ success: true, message: 'Welcome to ruby roda vue world' })
        response.status = 200
        JSON.pretty_generate(output)
      end

      # app part

      r.root do
        File.read(File.join('dist', 'index.html'))
      end

      r.get String do |_parsed_request|
        File.read(File.join('dist', 'index.html'))
      end

      # auth
      r.on 'verify_google_token' do
        r.post do
          begin
            request_body = JSON.parse(r.body.read)
            access_token = request_body['access_token']
            user_info = fetch_user_info(access_token)
            response.status = 200
            user_info.to_json # Assuming user_info is a hash
          rescue JSON::ParserError => e
            response.status = 400
            { error: 'Invalid JSON', details: e.message }.to_json
          rescue => e
            puts "Error: #{e.message}"
            response.status = 500
            { error: 'Internal Server Error', details: e.message }
          end
        end
      end
    end

    def fetch_user_info(access_token)
      require 'net/http'
      require 'json'


      uri = URI('https://www.googleapis.com/oauth2/v3/userinfo')
      uri.query = URI.encode_www_form(access_token: access_token)

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
    # rubocop:enable Metrics/BlockLength
  end
end
