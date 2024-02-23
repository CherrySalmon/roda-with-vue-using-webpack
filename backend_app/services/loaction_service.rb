# frozen_string_literal: true

require_relative '../policies/location_policy'

module Todo
  # Manages Location requests
  class LocationService
    # Custom error classes
    class ForbiddenError < StandardError; end
    class LocationNotFoundError < StandardError; end

    # Lists all locations, if authorized
    def self.list_all(requestor)
      verify_policy(requestor, :view)
      locations = Location.all.map(&:attributes)
      locations || raise(ForbiddenError, 'You have no access to list locations.')
    end

    # Lists one locations based on the id, if authorized
    def self.get(requestor,location_id)
      verify_policy(requestor, :view)
      location = Location.first(id: location_id)
      location.attributes || raise(ForbiddenError, 'You have no access to list locations.')
    end


    # Creates a new location, if authorized
    def self.create(requestor, location_data)
      verify_policy(requestor, :create)
      location = Location.create(location_data) || raise("Failed to create location.")
      location
    end

    # Updates an existing location, if authorized
    def self.update(requestor, location_id, location_data)
      verify_policy(requestor, :update, location_id)
      location = Location.first(id: location_id) || raise(LocationNotFoundError, "Location with ID #{location_id} not found.")
      location.update(location_data) || raise("Failed to update location with ID #{location_id}.")
    end

    # Removes an location, if authorized
    def self.remove(requestor, target_id)
      verify_policy(requestor, :delete, target_id)
      location = Location.first(id: target_id) || raise(LocationNotFoundError, "Laction with ID #{target_id} not found.")
      location.delete
    end

    private

    # Checks authorization for the requested action
    def self.verify_policy(requestor, action = nil, target_id = nil)
      policy = LocationPolicy.new(requestor, target_id)
      action_check = action ? policy.send("can_#{action}?") : true
      raise(ForbiddenError, 'You have no access to perform this action.') unless action_check

      requestor
    end
  end
end
