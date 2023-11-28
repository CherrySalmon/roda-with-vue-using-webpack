# frozen_string_literal: true

require 'sequel'
require 'json'
module BackendApp
  # Domain model for a single todo
  class Todo < Sequel::Model
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'todo',
            attributes:
          }
        },
        options
      )
    end

    private

    def attributes
      {
        id:,
        name:,
        due_date:,
        completed:
      }
    end
  end
end
