# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    # Create locations table
    create_table(:locations) do
      primary_key :id
      foreign_key :course_id, :courses # Links location to a specific course

      String :name
      Float :latitude
      Float :longitude
      DateTime :created_at
      DateTime :updated_at

      unique %i[latitude longitude]
    end
  end
end
