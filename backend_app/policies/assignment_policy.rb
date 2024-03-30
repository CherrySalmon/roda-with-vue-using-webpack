# policies/assignment_policy.rb
module Todo
  class AssignmentPolicy # rubocop:disable Style/Documentation
    def initialize(requestor, course_roles)
        @requestor = requestor
        @course_roles = course_roles
    end

    def can_view?
        requestor_is_admin? || requestor_is_instructor? || requestor_is_staff? || requestor_is_owner? || self_enrolled?
    end

    def can_create?
        requestor_is_admin? || requestor_is_instructor? || requestor_is_staff? || requestor_is_owner?
    end

    def can_update?
        requestor_is_admin? || requestor_is_instructor? || requestor_is_staff? || requestor_is_owner?
    end

    def can_delete?
        requestor_is_admin? || requestor_is_instructor? || requestor_is_staff? || requestor_is_owner?
    end

    # Summary of permissions
    def summary
        {
        can_view_all: can_view?,
        can_create: can_create?,
        can_update: can_update?,
        can_delete: can_delete?
        }
    end

    private

    def self_enrolled?
        @this_course&.accounts&.any? { |account| account.id == @requestor['account_id'] }
    end

    def requestor_is_admin?
        @requestor['roles'].include?('admin')
    end

    def requestor_is_instructor?
        @course_roles.include?('instructor')
    end

    def requestor_is_staff?
        @course_roles.include?('staff')
    end

    def requestor_is_owner?
        @course_roles.include?('owner')
    end
  end
end