# frozen_string_literal: true

require 'roda'
require 'json'
require_relative '../forms/markdown_file_form'

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
          output = { data: Todo.first(id: todo_id)}
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
          Todo.where(id: id).delete
          response['Content-Type'] = 'application/json'
          response.status = 200
          JSON.pretty_generate({ success: true, message: 'delete the todo' })
        rescue StandardError
          r.halt 500, { message: 'Database error' }.to_json
        end
      end

      r.on 'upload' do
        r.post do
          # Assuming `params[:file_metadata]` contains the metadata like { file_name: 'example.txt', file_type: 'text/plain' }
          result = Forms::MarkdownFileSchema.new.call(JSON.parse(r.body.read))
          if result.success?
            # Process the file upload
            # ...
            response['Content-Type'] = 'application/json'
            response.status = 200
            JSON.pretty_generate({ success: true, message: 'File uploaded successfully' })
          else
            r.halt 422, { message: 'Validation error' }.to_json
          end
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
    end
    # rubocop:enable Metrics/BlockLength
  end
end
