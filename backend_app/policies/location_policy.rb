# frozen_string_literal: true

module Todo
  # Policy to determine if an requestor can view, edit, or delete a particular course
  class LocationPolicy
    def initialize(requestor, location)
      @requestor = requestor
      @location = location
    end

    # Only the course's teachers and staff can update a location
    def can_create? #instructor/staff #expect student
      requestor_is_admin?
    end

    # Everyone can read a location
    def can_view?
      true
    end

    # Only the course's teachers and staff can update a location
    def can_update? #instructor/staff #expect student
      requestor_is_admin?
    end

    # Only the course's teachers and staff can update a location
    def can_delete? #instructor/staff #expect student
      requestor_is_admin?
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
  end
end
