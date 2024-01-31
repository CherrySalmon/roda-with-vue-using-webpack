# frozen_string_literal: true
# models/account.rb

require 'sequel'

module Todo
  class Account < Sequel::Model
    many_to_one :role
    one_through_one :granted_permissions, join_table: :granted_permissions, left_key: :role_id, right_key: :permission_id

    # validation for the model
    plugin :validation_helpers
    def validate
      super
      validates_presence [:name, :email, :role_id]
      validates_unique :email
    end

    def attributes
      {
        id:,
        name:,
        email:,
        role_id:
      }
    end

    def permissions_for_account
      role.granted_permissions.map { |gp| gp.permission.name }
    end

    def to_hash_with_role
      permissions = role.granted_permissions.map { |gp| gp.permission.name }
      {
        id:,
        name:,
        email:,
        role: role&.name,
        permissions:
      }
    end
  end
end
