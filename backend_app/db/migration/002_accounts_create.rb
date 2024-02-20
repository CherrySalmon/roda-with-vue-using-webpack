# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      String :name
      foreign_key :role_id, :roles
      String :email, null: false
      String :sso_token
    end
  end
end
