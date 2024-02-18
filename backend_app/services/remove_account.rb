# frozen_string_literal: true

require_relative '../policies/account_policy'

module Todo
  # Add a visitor to another owner's existing dramalist
  class RemoveAccount
    # Error for owner cannot be visitor
    class ForbiddenError < StandardError
      def message
        'You are not allowed to remove that account'
      end
    end

    def self.call(auth:, target_id:)
      target_account = Account.first(id: target_id)
      policy = AccountPolicy.new(auth, target_account)
      raise ForbiddenError unless policy.can_delete?

      target_account.delete
    end
  end
end
