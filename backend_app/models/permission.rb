# frozen_string_literal: true
# models/permission.rb

require 'sequel'

module Todo
  class Permission < Sequel::Model
    # You can also add validations for the model
    plugin :validation_helpers

    def validate
      super
      validates_presence :name
      validates_unique :name
    end
  end
end
