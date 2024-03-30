# models/assignment.rb

require 'sequel'

module Todo
  class Assignment < Sequel::Model
    plugin :validation_helpers
    plugin :timestamps, update_on_create: true

    many_to_one :course
    
    one_to_many :submissions

    plugin :timestamps, update_on_create: true
    def validate
      super
      validates_presence [:name, :course_id]
    end
  end
end
