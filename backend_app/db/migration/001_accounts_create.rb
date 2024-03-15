# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      String :user_id, unique: true, null: false
      String :email, unique: true, null: false
      String :name
      String :password_hash
      DateTime :created_at, null: false
      DateTime :last_login
      index :user_id
      index :email
    end
  end
end
