# frozen_string_literal: true

require 'sequel'

Sequel.migration do
    change do
      create_table(:courses) do
        primary_key :id
        String :name, null: false
        String :semester, null: false
        DateTime :created_at
        DateTime :updated_at
        String :logo
        DateTime :start_time
        String :repeat
        Float :duration
        Integer :occurrence
      end
    end
  end