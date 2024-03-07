# frozen_string_literal: true

require 'sequel'

Sequel.migration do
    change do
      create_table(:account_course_roles) do
        primary_key :id
        foreign_key :account_id, :accounts
        foreign_key :course_id, :courses
        String :roles, text: true
      end
    end
  end