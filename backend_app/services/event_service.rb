# frozen_string_literal: true

require_relative '../policies/event_policy'

module Todo
  # Manages event requests
  class EventService
    # Custom error classes
    class ForbiddenError < StandardError; end
    class EventNotFoundError < StandardError; end

    # Lists course's event, if authorized
    def self.list(requestor, course_id)
      course = find_course(course_id)
      verify_policy(requestor, :view, course)
      events = Event.list_event(course_id)
      events || raise(ForbiddenError, 'You have no access to list events.')
    end

    # Creates a new event, if authorized
    def self.create(requestor, event_data, course_id)
      puts "event_data: #{event_data}"
      course = find_course(course_id)
      puts "course: #{course}"

      verify_policy(requestor, :create, course)
      Event.add_event(course_id, event_data)
    end

    def self.find_course(course_id)
      Course.first(id: course_id) || raise(CourseNotFoundError, "Course with ID #{course_id} not found.")
    end

    # Checks authorization for the requested action
    def self.verify_policy(requestor, action = nil, course = nil)
      policy = EventPolicy.new(requestor, course)
      action_check = action ? policy.send("can_#{action}?") : true
      raise(ForbiddenError, 'You have no access to perform this action.') unless action_check

      requestor
    end
  end
end
