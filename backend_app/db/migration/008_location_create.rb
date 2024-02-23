# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    # Create locations table
    create_table(:locations) do
      primary_key :id
      String :name
      Float :latitude
      Float :longitude
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
