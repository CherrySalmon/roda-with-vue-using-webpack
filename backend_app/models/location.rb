# frozen_string_literal: true
# models/location.rb

require 'sequel'

module Todo
  class Location < Sequel::Model
    # validation for the model
    plugin :validation_helpers
    plugin :timestamps, update_on_create: true

    # def validate
    #   super
    #   validates_presence [:email]
    #   validates_unique :email
    # end

    # # Add a new account with the specified data
    # def self.add_account(user_data)
    #   account = Account.create(
    #     name: user_data[:name],
    #     email: user_data[:email],
    #     sso_token: user_data[:sso_token],
    #     avatar: user_data[:avatar]
    #   )
    #   # Find or create roles and associate them with the account
    #   user_data[:roles].each do |role_name|
    #     role = Role.first(name: role_name)
    #     account.add_role(role)
    #   end
    #   account
    # end

    # def update_account(user_data)
    #   # Update account attributes directly
    #   self.name = user_data['name'] if user_data['name']
    #   self.email = user_data['email'] if user_data['email']
    #   self.avatar = user_data['avatar'] if user_data['avatar']
    #   self.sso_token = user_data['sso_token'] if user_data['sso_token']

    #   save_changes

    #   # Clear existing roles and associate new roles
    #   remove_all_roles
    #   user_data['roles'].each do |role_name|
    #     role = Role.first(name: role_name)
    #     add_role(role) if role
    #   end
    #   true
    # end

    def attributes
      {
        id:,
        name:,
        longitude:,
        latitude:,
      }
    end
  end
end
