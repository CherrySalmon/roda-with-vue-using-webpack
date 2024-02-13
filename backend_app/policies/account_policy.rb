# frozen_string_literal: true

class AccountPolicy # rubocop:disable Style/Documentation
  attr_reader :requestor, :this_account

  def initialize(requestor, account)
    @requestor = requestor
    @this_account = account
  end

  # Admin can view any account; account owners can view their own account
  def can_view?
    requestor_is_admin? || self_request?
  end

  # Admin can update any account; account owners can update their own account
  def can_update?
    requestor_is_admin? || self_request?
  end

  # Admin can delete any account; account owners can delete their own account
  def can_delete?
    requestor_is_admin? || self_request?
  end

  # Summary of permissions
  def summary
    {
      can_view: can_view?,
      can_update: can_update?,
      can_delete: can_delete?
    }
  end

  private

  # Check if the requestor is the owner of the account
  def self_request?
    requestor == this_account
  end

  # Check if the requestor has an admin role
  def requestor_is_admin?
    requestor.role == 'Admin'
  end
end
