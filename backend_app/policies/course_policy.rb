# frozen_string_literal: true

module Todo
  # Policy to determine if an account can view, edit, or delete a particular course
  class CoursePolicy
    def initialize(account, course, auth_scope = nil)
      @account = account
      @course = course
      @auth_scope = auth_scope
    end

    # Only the course's teachers can create a course
    def can_create?
      course_teachers_include_account?
    end

    # Admins and the course's teachers, staff, and students can read a course
    def can_view?
      account_is_admin? || course_involves_account?
    end

    # Only Admins and the course's teachers and staff can update a course
    def can_update?
      account_is_admin? || course_teachers_include_account? || course_staffs_include_account?
    end

    # Only Admins and the course's teacher and staff can delete a course
    def can_delete?
      account_is_admin? || course_teachers_include_account? || course_staffs_include_account?
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

    def account_is_admin?
      @account.role == 'Admin'
    end

    def course_involves_account?
      @course.teachers.include?(@account) ||
        @course.staffs.include?(@account) ||
        @course.students.include?(@account)
    end

    def course_teachers_include_account?
      @course.teachers.include?(@account)
    end

    def course_staffs_include_account?
      @course.staffs.include?(@account)
    end
  end
end
