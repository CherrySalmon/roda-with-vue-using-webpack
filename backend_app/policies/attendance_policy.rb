# frozen_string_literal: true

module Todo
  # Policy to determine if an account can view, edit, or delete a particular course
  class AttendancePolicy
    def initialize(requestor, course = nil)
      @requestor = requestor
      @this_course = course
    end

    # Student can create a attendance;
    def can_create?
      self_enrolled?
    end

    # Student can view the attendance;
    def can_view?
      self_enrolled?
    end

    # Student can update the attendance;
    def can_update?
      self_enrolled?
    end

    # Summary of permissions
    def summary
      {
        can_view: can_view?,
        can_create: can_create?,
        can_update: can_update?
      }
    end

    private

    # Check if the requestor is enrolled in the course
    def self_enrolled?
      puts 'requestor id: ', @requestor
      @this_course&.accounts&.any? { |account| account.id == @requestor['account_id'] }
    end
  end
end
