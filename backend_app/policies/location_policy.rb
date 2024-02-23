# frozen_string_literal: true

module Todo
  # Policy to determine if an account can view, edit, or delete a particular course
  class LocationPolicy
    def initialize(account, course)
      @account = account
      @course = course
      @auth_scope = auth_scope
    end

    # Only the course's teachers and staff can update a location
    def can_create?
      course_teachers_or_staff_include_account?
    end

    # Everyone can read a location
    def can_view?
      true
    end

    # Only the course's teachers and staff can update a location
    def can_update?
      course_teachers_or_staff_include_account?
    end

    # Only the course's teachers and staff can update a location
    def can_delete?
      course_teachers_or_staff_include_account?
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

    def course_teachers_or_staff_include_account?
      @course.teachers.include?(@account) ||
        @course.staffs.include?(@account)
    end
  end
end
