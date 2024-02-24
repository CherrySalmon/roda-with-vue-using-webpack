# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      foreign_key :course_id, :courses # Links attendance to a specific course

      Integer :location_id
      String :name, null: false
      DateTime :start_time
      DateTime :end_time

      unique %i[start_time end_time]
    end
  end
end
