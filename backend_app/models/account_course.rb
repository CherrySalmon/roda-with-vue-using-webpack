# models/account_course.rb

require 'sequel'

module Todo
  class AccountCourse < Sequel::Model(:account_course_roles)
    many_to_one :account
    many_to_one :course
  end
end