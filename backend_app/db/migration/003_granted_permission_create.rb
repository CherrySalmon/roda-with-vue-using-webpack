# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:granted_permissions) do
      foreign_key :role_id, :roles, null: false, on_delete: :cascade
      foreign_key :permission_id, :permissions, null: false, on_delete: :cascade
      primary_key [:role_id, :permission_id]
      # Ensures that each role-permission pair is unique
      unique [:role_id, :permission_id]
    end
  end
end
