# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:permissions) do
      primary_key :id
      String :name, unique: true, null: false
    end
  end
end
