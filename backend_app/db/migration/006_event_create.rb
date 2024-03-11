# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      foreign_key :course_id, :courses, on_delete: :cascade
      foreign_key :location_id, :locations, on_delete: :cascade

      String :name, null: false
      DateTime :start_time
      DateTime :end_time

      unique %i[start_time end_time]
    end
  end
end
