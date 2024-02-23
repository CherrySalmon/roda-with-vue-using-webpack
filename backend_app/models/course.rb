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
      # Fetch courses directly associated with the given account_id
      # through the account_course_roles join table
      Course.join(:account_course_roles, course_id: :id)
            .where(account_id:)
            .select_all(:courses)
            .all
            .map do |course|
              course.attributes(account_id)
            end
    end

    def self.create_course(account_id, course_data)
      course = Course.create(course_data)
      account_course_role = AccountCourse.find_or_create(account_id: account_id, course_id: course.id)
      account_course_role.update(roles: 'owner')
      course
    end

    def attributes(account_id = nil)
      {
        id: id,
        name: name,
        semester: semester,
        created_at: created_at,
        updated_at: updated_at,
        logo: logo,
        start_time: start_time,
        repeat: repeat,
        duration: duration,
        occurrence: occurrence,
        enroll_identity: account_id ? get_enroll_identity(account_id) : {}
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
      AccountCourse.where(course_id: self.id).map do |enrollment|
        account = Account.first( id: enrollment.account_id)
        {
          account_id: account.id,
          email: account.email,
          name: account.name,
          avatar: account.avatar,
          enroll_identity: enrollment.roles
        }
      end
    end

    private

    def get_enroll_identity(account_id)
      account_course_role = AccountCourse.first(account_id: account_id, course_id: self.id)
      account_course_role ? account_course_role.roles : nil
    end

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
