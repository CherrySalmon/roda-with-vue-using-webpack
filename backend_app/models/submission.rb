require 'sequel'

module Todo
  class Submission < Sequel::Model
    plugin :validation_helpers
    plugin :timestamps, update_on_create: true

    many_to_one :assignment
    many_to_one :account

    def validate
      super
      validates_presence [:assignment_id, :content]
    end

    def attributes
      {
        id:,
        account_id: account.id,
        account_name: account.name,
        account_email: account.email,
        assignment_id:,
        file_url:,
        name:,
        content:,
        comment:,
        created_at:,
        updated_at:
      }
    end
  end
end
