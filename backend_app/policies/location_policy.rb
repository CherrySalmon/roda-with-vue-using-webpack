# frozen_string_literal: true

module Todo
  # Policy to determine if an requestor can view, edit, or delete a particular course
  class LocationPolicy
    def initialize(requestor, course_roles)
      @requestor = requestor
      @course_roles = course_roles
    end

    # Only the course's teachers and staff can update a location
    def can_create? #expect student
      requestor_is_not_student?
    end

    # Everyone can read a location
    def can_view?
      true
    end

    # Only the course's teachers and staff can update a location
    def can_update? #expect student
      requestor_is_not_student?
    end

    # Only the course's teachers and staff can update a location
    def can_delete? #expect student
      requestor_is_not_student?
    end

    def summary
      {
        can_create: can_create?,
        can_view: can_view?,
        can_update: can_update?,
        can_delete: can_delete?
      }
    end

    private

    # Check if the requestor has an admin role
    def requestor_is_admin?
      @requestor['roles'].include?('admin')
    end

    def requestor_is_not_student?
      !@course_roles.include?('student')
    end
  end
end
