# frozen_string_literal: true

require 'sequel'
require 'json'
module BackendApp
  # Domain model for an account
  class Account < Sequel::Model
    one_to_many :notes

    # additional logic and methods for the Account model
  end
end
