# services/assignment_service.rb

require_relative '../policies/assignment_policy'

module Todo
  class AssignmentService
    class ForbiddenError < StandardError; end
    class AssignmentNotFoundError < StandardError; end

    def self.list(requestor, course_id)
      verify_policy(requestor, :view, course_id)
      Assignment.where(course_id: course_id).map(&:values)
    end

    def self.create(requestor, course_id, assignment_data)
      # Assuming that AssignmentPolicy defines :create permission
      verify_policy(requestor, :create, course_id)
      assignment = Assignment.new(assignment_data)
      assignment.course_id = course_id
      raise "Invalid assignment data." unless assignment.valid?
      assignment.save
      assignment.values
    end

    def self.find(requestor, course_id, assignment_id)
      # Assuming that AssignmentPolicy defines :view permission
      verify_policy(requestor, :view, course_id)
      assignment = Assignment.first(id: assignment_id)
      raise AssignmentNotFoundError, "Assignment not found." unless assignment
      assignment.values
    end

    def self.update(requestor, course_id, assignment_id, assignment_data)
      # Assuming that AssignmentPolicy defines :update permission
      verify_policy(requestor, :update, course_id)
      assignment = Assignment[assignment_id]
      raise AssignmentNotFoundError, "Assignment not found." unless assignment
      assignment.update(assignment_data)
      assignment.values
    end

    def self.delete(requestor, course_id, assignment_id)
      # Assuming that AssignmentPolicy defines :delete permission
      verify_policy(requestor, :delete, course_id)
      assignment = Assignment[assignment_id]
      raise AssignmentNotFoundError, "Assignment not found." unless assignment
      assignment.destroy
    end

    private

    def self.verify_policy(requestor, action = nil, course_id = nil)
      course_roles = AccountCourse.where(account_id: requestor['account_id'], course_id: course_id).map do |role|
        role.role.name
      end
      policy = AssignmentPolicy.new(requestor, course_roles)
      action_check = policy.send("can_#{action}?")
      raise(ForbiddenError, "You are not authorized to perform this action.") unless action_check
      true
    end
  end
end
