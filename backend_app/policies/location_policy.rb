# frozen_string_literal: true

module Todo
    # Policy to determine if an account can view, edit, or delete a particular course
    class LocationPolicy
      def initialize(account, course, auth_scope = nil)
        @account = account
        @course = course
        @auth_scope = auth_scope
      end

      # Only the course's teachers and staff can update a location
      def can_create?
        can_write? && course_teachers_or_staff_include_account?
      end
      # Everyone can read a location
      def can_view?
        can_read?
      end

      # Only the course's teachers and staff can update a location
      def can_update?
        can_write? && course_teachers_or_staff_include_account?
      end

      # Only the course's teachers and staff can update a location
      def can_delete?
        can_write? && course_teachers_or_staff_include_account?
      end

      def summary
        {
          can_create:can_create?,
          can_view: can_view?,
          can_update: can_update?,
          can_delete: can_delete?,
        }
      end

      private

      def can_read?
        @auth_scope ? @auth_scope.can_read?('locations') : false
      end

      def can_write?
        @auth_scope ? @auth_scope.can_write?('locations') : false
      end

      def course_teachers_or_staff_include_account?
        @course.teachers.include?(@account) ||
        @course.staffs.include?(@account)
      end
    end
  end
