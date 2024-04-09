# frozen_string_literal: true

module Todo
  class SubmissionPolicy # rubocop:disable Style/Documentation
    def initialize(requestor, course_roles, submission_owner_id=nil)
      @requestor = requestor
      @course_roles = course_roles
      @submission_owner_id = submission_owner_id
    end

    def can_view?
      requestor_is_admin? || requestor_is_instructor? || requestor_is_staff? || requestor_is_owner? || self_submitted?
    end

    def can_create?
      requestor_is_student? || requestor_is_instructor? || requestor_is_staff? || requestor_is_owner?
    end

    def can_update?
      requestor_is_instructor? || requestor_is_staff? || requestor_is_owner? || self_submitted?
    end

    def can_delete?
      requestor_is_instructor? || requestor_is_staff? || requestor_is_owner? || self_submitted?
    end

    # Summary of permissions
    def summary
      {
        can_view: can_view?,
        can_create: can_create?,
        can_update: can_update?,
        can_delete: can_delete?
      }
    end

    private

    def self_submitted?
      @requestor['account_id'] == @submission_owner_id
    end

    def requestor_is_student?
      @course_roles.include?('student')
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
