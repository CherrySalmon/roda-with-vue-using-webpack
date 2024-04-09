require 'sequel'

module Todo
  class Submission < Sequel::Model
    plugin :validation_helpers
    plugin :timestamps, update_on_create: true

    many_to_one :assignment
    many_to_one :student

    def validate
      super
      validates_presence [:assignment_id, :content]
    end
  end
end
