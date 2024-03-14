# frozen_string_literal: true

# models/course.rb

require 'sequel'

module Todo
  class Course < Sequel::Model
    plugin :validation_helpers
    many_to_many :events
    one_to_many :locations
  
    many_to_many :attendances, join_table: :account_course_roles
    many_to_many :roles, join_table: :account_course_roles
    many_to_many :accounts, join_table: :account_course_roles

    plugin :timestamps, update_on_create: true

    def validate
      super
      validates_presence %i[name]
    end

    def self.listByAccountID(account_id)
      # Fetching courses with a join on account_course_roles table
      courses =  AccountCourse.where(account_id: account_id).map do |ac|
        ac.course.attributes(account_id)
      end
      courses
    end

    def self.create_course(account_id, course_data)
      course = Course.create(course_data)
      owner_role = Role.first(name: 'owner')
      account = Account.first(id: account_id)

      if course && owner_role
        account_course = AccountCourse.create(role: owner_role, account: account, course: course)
      else
        raise Sequel::Rollback, "Course or owner role not found"
      end
      course
    end

    def attributes(account_id = nil)
      {
        id: id,
        name: name,
        created_at: created_at,
        updated_at: updated_at,
        logo: logo,
        start_at: start_at,
        end_at: end_at,
        enroll_identity: account_id ? get_enroll_identity(account_id) : {}
      }
    end

    def add_or_update_enrollments(enrolled_data)
      enrolled_data.each do |enrollment|
        account = add_or_find_account(enrollment['email'])
        update_course_account_roles(account, enrollment['roles'])
      end
    end

    def update_single_enrollment(account_id, enrolled_data)
      account = Account.first(id: account_id)
      account.update(email: enrolled_data['email'])
      update_course_account_roles(account, enrolled_data['roles'])
    end

    def get_enrollments
      AccountCourse.where(course_id: self.id).map do |enrollment|
        account = Account.first(id: enrollment.account_id).attributes
      end
    end

    private

    def get_enroll_identity(account_id)
      account_course_role = AccountCourse.where(account_id: account_id, course_id: self.id).map do |role|
        role.role.name
      end
      account_course_role
    end

    def add_or_find_account(email)
      account = Account.first(email: email)
      unless account
        account = Account.create(email: email)
        role = Role.first(name: 'member')
        account.add_role(role)
      end
      account
    end

    def update_course_account_roles(account, roles_string)
      # Split the roles_string into an array of role names
      role_names = roles_string.split(',')
    
      # Find existing roles for the account in the context of the course
      existing_roles = AccountCourse.where(account_id: account.id, course_id: self.id).map(&:role)
    
      # Delete any roles not included in the new list
      existing_roles.each do |existing_role|
        unless role_names.include?(existing_role.name)
          AccountCourse.where(account_id: account.id, course_id: self.id, role_id: existing_role.id).delete
        end
      end
    
      # Add or update roles from the roles_string
      role_names.each do |role_name|
        role = Role.first(name: role_name)
        next unless role
    
        # Find or create the AccountCourse entry for each role
        account_course_entry = AccountCourse.find_or_create(account_id: account.id, course_id: self.id, role_id: role.id)
    
        # Assuming you might need to update additional attributes in AccountCourse, you can do it here
        # account_course_entry.update(...)
      end
    end    
  end
end
