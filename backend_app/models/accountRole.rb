# frozen_string_literal: true

require 'sequel'

module Todo
  class AccountRole < Sequel::Model
    # You can also add validations for the model
    plugin :validation_helpers

    def validate
      super
      validates_presence :role_id
      validates_presence :account_id
    end
  end
end
