# frozen_string_literal: true
# models/location.rb

require 'sequel'

module Todo
  class Location < Sequel::Model
    # validation for the model
    plugin :validation_helpers
    plugin :timestamps, update_on_create: true

    many_to_one :course, class: :'Todo::Course'
    one_to_many :events, class: :'Todo::Event', key: :location_id

    def validate
      super
      validates_presence %i[name course_id]
    end

    def attributes
      {
        id:,
        course_id:,
        name:,
        longitude:,
        latitude:,
      }
    end
  end
end
