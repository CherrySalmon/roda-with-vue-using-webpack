# frozen_string_literal: true

class CoursePolicy
  def initialize(requestor, course = nil, course_roles = nil)
    @requestor = requestor
    @this_course = course
    @course_roles = course_roles
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
    puts "requestor_is_staff? #{requestor_is_staff?}"
    requestor_is_instructor? || requestor_is_teacher? || requestor_is_admin? || requestor_is_staff?
  end

  # Admin can delete any course;
  def can_delete?
    requestor_is_admin? || requestor_is_instructor? || requestor_is_teacher?
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
    enroll = @this_course&.accounts&.any? { |account| account.id == @requestor['account_id'] }
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
