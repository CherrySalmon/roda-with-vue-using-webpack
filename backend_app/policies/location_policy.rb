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
      requestor_is_owner? || requestor_is_instructor? || requestor_is_staff?
    end

    # Everyone can read a location
    def can_view?
      true
    end

    # Only the course's teachers and staff can update a location
    def can_update? #expect student
      requestor_is_owner? || requestor_is_instructor? || requestor_is_staff?
    end

    # Only the course's teachers and staff can update a location
    def can_delete? #expect student
      requestor_is_owner? || requestor_is_instructor? || requestor_is_staff?
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

    def requestor_is_instructor?
      roles_array = Array(@course_roles).flatten.map(&:to_s).flat_map { |role| role.split(',') }
      roles_array.include?('instructor')
    end

    def requestor_is_staff?
      roles_array = Array(@course_roles).flatten.map(&:to_s).flat_map { |role| role.split(',') }
      roles_array.include?('staff')
    end

    def requestor_is_owner?
      roles_array = Array(@course_roles).flatten.map(&:to_s).flat_map { |role| role.split(',') }
      roles_array.include?('owner')
    end
  end
end
