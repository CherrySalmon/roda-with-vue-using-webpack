require 'sequel'

Sequel.migration do
  change do
    # Create the 'submission' table unless it already exists
    create_table?(:submissions) do
      primary_key :id
      foreign_key :account_id, :accounts, on_delete: :cascade
      foreign_key :role_id, :roles, on_delete: :cascade
      foreign_key :assignment_id, :assignments, on_delete: :cascade
      String :name
      String :file_url
      String :content
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
