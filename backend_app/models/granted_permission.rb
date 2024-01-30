# frozen_string_literal: true
# models/granted_permission.rb

require 'sequel'

module Todo
  class GrantedPermission < Sequel::Model
    # You can also add validations for the model
    plugin :validation_helpers

    many_to_one :role
    many_to_one :permission

    def validate
      super
      validates_presence :role_id
      validates_presence :permission_id
    end
  end
end
