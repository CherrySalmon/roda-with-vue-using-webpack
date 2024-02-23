# frozen_string_literal: true

require_relative '../policies/attendance_policy'

module Todo
  # Manages attendance requests
  class AttendanceService
    # Custom error classes
    class ForbiddenError < StandardError; end
    class AttendanceNotFoundError < StandardError; end

    # Lists joined course's attendance, if authorized
    def self.list(requestor, course_id)
      course = find_course(course_id)
      verify_policy(requestor, :view, course)
      attendances = Attendance.list_attendance(requestor['id'], course_id)
      attendances || raise(ForbiddenError, 'You have no access to list attendance.')
    end

    # Creates a new attendance, if authorized
    def self.create(requestor, attendance_data, course_id)
      puts "attendance_data: #{attendance_data}"
      course = find_course(course_id)
      puts "course: #{course}"
      if course&.accounts
        course.accounts.each do |account|
          puts account.id
        end
      else
        puts "No accounts associated with this course or the course doesn't exist."
      end
      verify_policy(requestor, :create, course)
      Attendance.add_attendance(requestor['id'], course_id, attendance_data)
    end

    def self.find_course(course_id)
      Course.first(id: course_id) || raise(CourseNotFoundError, "Course with ID #{course_id} not found.")
    end

    # Checks authorization for the requested action
    def self.verify_policy(requestor, action = nil, course = nil)
      policy = AttendancePolicy.new(requestor, course)
      action_check = action ? policy.send("can_#{action}?") : true
      raise(ForbiddenError, 'You have no access to perform this action.') unless action_check

      requestor
    end
  end
end
