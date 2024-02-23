# frozen_string_literal: true
# models/location.rb

require 'sequel'

module Todo
  class Location < Sequel::Model
    # validation for the model
    plugin :validation_helpers
    plugin :timestamps, update_on_create: true

    def attributes
      {
        id:,
        name:,
        longitude:,
        latitude:,
      }
    end
  end
end
