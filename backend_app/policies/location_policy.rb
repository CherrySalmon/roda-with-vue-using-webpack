# frozen_string_literal: true

module Todo
  # Policy to determine if an requestor can view, edit, or delete a particular course
  class LocationPolicy
    def initialize(requestor, location)
      @requestor = requestor
      @location = location
    end

    # Only the course's teachers and staff can update a location
    def can_create?
      requestor_is_admin?
    end

    # Everyone can read a location
    def can_view?
      true
    end

    # Only the course's teachers and staff can update a location
    def can_update?
      requestor_is_admin?
    end

    # Only the course's teachers and staff can update a location
    def can_delete?
      requestor_is_admin?
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

    # Check if the requestor has an admin role
    def requestor_is_admin?
      @requestor['roles'].include?('admin')
    end
  end
end



  # # Admin can view any account;
  # def can_view_all?
  #   requestor_is_admin?
  # end

  # def can_create?
  #   @requestor!= nil
  # end

  # # Admin can view any account; account owners can view their own account
  # def can_view_single?
  #   requestor_is_admin? || self_request?
  # end

  # # Admin can update any account; account owners can update their own account
  # def can_update?
  #   requestor_is_admin? || self_request?
  # end

  # # Admin can delete any account; account owners can delete their own account
  # def can_delete?
  #   requestor_is_admin? || self_request?
  # end

  # # Summary of permissions
  # def summary
  #   {
  #     can_view_all: can_view_all?,
  #     can_view_single: can_view_single?,
  #     can_update: can_update?,
  #     can_delete: can_delete?
  #   }
  # end

  # private

  # # Check if the requestor is the owner of the account
  # def self_request?
  #   @requestor['id'] == @this_account
  # end

  # # Check if the requestor has an admin role
  # def requestor_is_admin?
  #   @requestor['roles'].include?('admin')
  # end
