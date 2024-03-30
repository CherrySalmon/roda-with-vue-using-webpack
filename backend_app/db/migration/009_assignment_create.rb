require 'sequel'

Sequel.migration do
  change do
    # Create the 'assignment' table unless it already exists
    create_table?(:assignments) do
      primary_key :id
      foreign_key :course_id, :courses, on_delete: :cascade
      String :name, null: false
      Text :description
      DateTime :due_at
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
