# frozen_string_literal: true

require 'sequel'

# Define the Note model
class Note < Sequel::Model
  # Define the associations (if any)
  many_to_one :account, key: :user_id
  plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true

  def self.create_note(note_params)
    Note.create(note_params)
  end

  def self.find_by_id(id)
    Note.first(note_id: id)
  end

  def self.all_notes
    Note.all
  end
  # Return all attributes of a note
  def attributes
    {
      id:,
      user_id:,
      note_id:,
      title:,
      content:,
      keywords:,
      summary:,
      comment:,
      actions:,
      created_at:,
      updated_at:,
      metadata:
    }
  end
end
