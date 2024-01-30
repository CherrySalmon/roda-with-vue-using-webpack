# routes/todos.rb

module Todo
  module Routes
    class Todos < Roda
      route do |r|
        r.on do
          r.get do
            response['Content-Type'] = 'application/json'
            output = { data: Todo.all }
            response.status = 200
            JSON.pretty_generate(output)
          end
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

          r.delete String do |id|
            Todo.where(id:).delete
            response['Content-Type'] = 'application/json'
            response.status = 200
            JSON.pretty_generate({ success: true, message: 'delete the todo' })
          rescue StandardError
            r.halt 500, { message: 'Database error' }.to_json
          end
        end
      end
    end
  end
end
