# services/assignment_service.rb

require_relative '../policies/submission_policy'

module Todo
  class SubmissionService
    class ForbiddenError < StandardError; end
    class SubmissionNotFoundError < StandardError; end

    def self.create(requestor, course_id, assignment_id, submission_data)
      verify_policy(requestor, :create, course_id, assignment_id)
      submission = Submission.new(submission_data)
      assignment = Assignment.first(id: assignment_id)
      submission.assignment = assignment
      raise "Invalid submission data." unless submission.valid?
      submission.save
      submission.values
    end

    def self.list(requestor, course_id, assignment_id)
      verify_policy(requestor, :view, course_id, assignment_id)
      Submission.where(assignment_id: assignment_id).map(&:values)
    end

    def self.find(requestor, course_id, assignment_id, submission_id)
      verify_policy(requestor, :view, course_id, assignment_id, submission_id)
      submission = Submission.first(id: submission_id)
      raise SubmissionNotFoundError, "Submission not found." unless submission
      submission.values
    end

    def self.update(requestor, course_id, assignment_id, submission_id, submission_data)
      verify_policy(requestor, :update, course_id, assignment_id, submission_id)
      submission = Submission[submission_id]
      raise SubmissionNotFoundError, "Submission not found." unless submission
      submission.update(submission_data)
      submission.values
    end

    def self.delete(requestor, course_id, assignment_id, submission_id)
      verify_policy(requestor, :delete, course_id, assignment_id, submission_id)
      submission = Submission[submission_id]
      raise SubmissionNotFoundError, "Submission not found." unless submission
      submission.destroy
    end

    private

    def self.verify_policy(requestor, action, course_id, assignment_id, submission_id = nil)
      course_roles = AccountCourse.where(account_id: requestor['account_id'], course_id: course_id).map(&:role).map(&:name)
      submission_owner_id = submission_id ? Submission[submission_id]&.account_id : nil
      policy = SubmissionPolicy.new(requestor, course_roles, submission_owner_id)

      action_check = policy.send("can_#{action}?")
      raise(ForbiddenError, "You are not authorized to perform this action.") unless action_check
      true
    end
  end
end
