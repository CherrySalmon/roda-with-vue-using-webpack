# frozen_string_literal: true

# models/course.rb

require 'sequel'

module Todo
  class Course < Sequel::Model
    plugin :validation_helpers
    many_to_many :accounts, join_table: :account_course_roles
    one_to_many :attendances, class: :'Todo::Attendance', key: :course_id
    one_to_many :events, class: :'Todo::Event', key: :course_id
    plugin :timestamps, update_on_create: true

    def validate
      super
      validates_presence %i[name semester]
    end

    def self.listByAccountID(account_id)
      # This will return an array of Course instances associated with the account_id
      Course.join(:account_course_roles, course_id: :id)
            .where(account_id:)
            .select_all(:courses)
      Course.all.map(&:attributes)
    end

    def attributes
      {
        id:,
        name:,
        semester:,
        created_at:,
        updated_at:,
        logo:,
        start_time:,
        repeat:,
        duration:,
        occurrence:
      }
    end

    def add_or_update_enrollments(enrolled_data)
      enrolled_data.each do |enrollment|
        account = add_or_find_account(enrollment['email'])
        update_course_account_roles(account, enrollment['roles'])
      end
    end

    def get_enrollments
      # Assuming AccountCourse model exists and represents the account_course_roles table
      AccountCourse.where(course_id: id).map do |enrollment|
        account = Account[enrollment.account_id]
        {
          account_id: account.id,
          email: account.email,
          roles: enrollment.roles
        }
      end
    end

    private

    def add_or_find_account(email)
      Account.find_or_create(email:)
    end

    def update_course_account_roles(account, roles_string)
      # Find or create the join model entry
      account_course_role = AccountCourse.find_or_create(account_id: account.id, course_id: id)
      account_course_role.update(roles: roles_string)
    end
  end
end
