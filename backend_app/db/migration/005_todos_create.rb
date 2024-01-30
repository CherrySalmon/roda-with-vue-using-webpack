# frozen_string_literal: true

require 'sequel'
Sequel.migration do
  change do
    create_table(:todos) do
      primary_key :id
      String :name, null: false
      DateTime :due_date
      Boolean :completed, default: false
    end
  end
end
