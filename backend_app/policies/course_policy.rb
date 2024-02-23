# frozen_string_literal: true

class CoursePolicy
  def initialize(requestor, course = nil)
    @requestor = requestor
    @this_course = course
  end

  # Admin can view any course;
  def can_view_all?
    requestor_is_admin?
  end

  # Teacher can create a course
  def can_create?
    requestor_is_teacher?
  end

  # Admin can view any course;
  def can_view?
    requestor_is_admin? || self_enrolled?
  end

  # Admin can update any course;
  def can_update?
    requestor_is_instructor? || requestor_is_staff? || requestor_is_admin?
  end

  # Admin can delete any course;
  def can_delete?
    requestor_is_admin? || requestor_is_instructor?
  end

  # Summary of permissions
  def summary
    {
      can_view_all: can_view_all?,
      can_view: can_view?,
      can_create: can_create?,
      can_update: can_update?,
      can_delete: can_delete?
    }
  end

  private

  # Check if the requestor is enrolled in the course
  def self_enrolled?
    enroll = @this_course&.accounts&.any? { |account| account.account_id == @requestor['account_id'] }
    enroll
  end

  # Check if the requestor has an admin role
  def requestor_is_admin?
    @requestor['roles'].include?('admin')
  end

  # Check if the requestor has an teacher role
  def requestor_is_teacher?
    @requestor['roles'].include?('teacher')
  end

  # Check if the requestor has an instructor role for the course
  def requestor_is_instructor?
    @requestor['roles'].include?('instructor')
  end
  # Check if the requestor has an staff role for the course
  def requestor_is_staff?
    @requestor['roles'].include?('staff')
  end
end
