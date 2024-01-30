module Todo
  class Authorization
    def self.permission(user_id, permission_id)
      account = Account.first(id: user_id)
      permissions = account.permissions_for_account
      permissions.include?(permission_id)
    end
  end
end
