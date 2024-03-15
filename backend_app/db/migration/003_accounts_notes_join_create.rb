# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_join_table(user_id: :accounts, notes_id: { table: :notes, type: :uuid })
  end
end
