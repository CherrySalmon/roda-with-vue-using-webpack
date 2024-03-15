# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:notes) do
      primary_key :id
      foreign_key :user_id, :accounts
      String :note_id, unique: true, null: false
      String :title
      Text :content, null: false
      String :keywords
      Text :summary
      Text :comment
      Text :actions
      DateTime :created_at, null: false
      DateTime :updated_at
      Jsonb :metadata
      index :note_id
      index :user_id
    end
  end
end
