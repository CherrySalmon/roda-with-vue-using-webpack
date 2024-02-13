# frozen_string_literal: true

class RolePolicy # rubocop:disable Style/Documentation
  attr_reader :requestor, :target_account

  def initialize(requestor, target_account)
    @requestor = requestor
    @target_account = target_account
  end

  # Admins or the account owner can read the role information
  def can_view?
    requestor_is_admin? || requestor_is_owner?
  end

  # Admins or the account owner can update roles, but only admins can assign admin roles
  def can_update?
    (requestor_is_admin? || requestor_is_owner?) && admin_role_assignable?
  end

  # Summary of permissions
  def summary
    {
      can_view: can_view?,
      can_update: can_update?
    }
  end

  private

  # Check if the requestor has an admin role
  def requestor_is_admin?
    requestor.role == 'Admin'
  end

  # Check if the requestor is the owner of the account
  def requestor_is_owner?
    requestor == target_account
  end

  # Check if the admin role is assignable by the requestor
  # You will need to implement the appropriate logic based on your application's rules
  def admin_role_assignable?
    # This is a placeholder for your logic to determine if an admin role can be assigned.
    # For example, you might have a rule that only super admins can assign admin roles,
    # or that an admin can only assign an admin role if they have a specific permission.
  end
end
