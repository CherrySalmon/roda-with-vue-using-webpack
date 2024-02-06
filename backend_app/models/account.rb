# frozen_string_literal: true
# models/account.rb

require 'sequel'

module Todo
  class Account < Sequel::Model
    # validation for the model
    plugin :validation_helpers
    many_to_many :roles, join_table: :account_roles
    def validate
      super
      validates_presence [:name, :email]
      validates_unique :email
    end

    # Add a new account with the specified data
    def self.add_account(user_data)
      account = Account.create(
        name: user_data[:name],
        email: user_data[:email],
        sso_token: user_data[:sso_token]
      )
      # Find or create roles and associate them with the account
      user_data[:roles].each do |role_name|
        role = Role.first(name: role_name)
        account.add_role(role)
      end
      account
    end

    def self.update_account(account_id, user_data)
      account = Account[account_id]

      if account
        # Update account attributes
        account.update(
          name: user_data['name'],
          email: user_data['email'],
          sso_token: user_data['sso_token']
        )

        puts user_data['roles']

        # Clear existing roles and associate new roles
        account.remove_all_roles

        user_data['roles'].each do |role_name|
          role = Role.first(name: role_name)
          account.add_role(role) if role
        end
      end
      account
    end

    def attributes
      {
        id:,
        name:,
        email:,
        roles: roles.map(&:name)
      }
    end
  end
end
