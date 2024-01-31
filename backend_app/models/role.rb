# frozen_string_literal: true
# models/role.rb

require 'sequel'

module Todo
  class Role < Sequel::Model
    # Define the one_to_many association
    one_to_many :accounts
    one_to_many :granted_permissions

    # You can also add validations for the model
    plugin :validation_helpers
    def validate
      super
      validates_presence :name
      validates_unique :name
    end

    def self.get_id_by_name(name)
      Role.where(name:).get(:id)
    end
  end
end
