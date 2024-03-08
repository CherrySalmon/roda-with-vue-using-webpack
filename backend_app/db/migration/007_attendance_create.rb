# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:attendances) do
      primary_key :id
      foreign_key :course_id, :courses, on_delete: :cascade
      foreign_key :account_id, :account_course_roles, on_delete: :cascade

      Integer :event_id
      String :name, null: false
      Float :latitude
      Float :longitude
      DateTime :created_at
      DateTime :updated_at

      unique %i[course_id account_id event_id]
    end
  end
end
