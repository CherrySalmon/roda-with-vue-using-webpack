# frozen_string_literal: true

# models/event.rb

require 'sequel'

module Todo
  class Event < Sequel::Model # rubocop:disable Style/Documentation
    plugin :validation_helpers

    many_to_one :course, class: :'Todo::Course'

    plugin :timestamps, update_on_create: true

    def validate
      super
      validates_presence %i[name location_id]
    end

    def self.list_event(course_id, location_id)
      events = Event.where(course_id: course_id, location_id: location_id).all
      events.map(&:values) # or any other way you wish to serialize the data
    end

    def self.add_event(course_id, event_details)
      event = Event.create(
        course_id: course_id,
        name: event_details[:name],
        location_id: event_details[:location_id],
        start_time: event_details[:start_time],
        end_time: event_details[:end_time],
      )

      event.values # Return the created event record details
    rescue StandardError => e
      # Handle error (e.g., validation errors)
      { error: "Failed to add event: #{e.message}" }
    end

    def attributes
      {
        id:,
        course_id:,
        location_id:,
        name:,
        start_time:,
        end_time:,
      }
    end
  end
end
