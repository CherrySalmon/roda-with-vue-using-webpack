# db/seeds.rb

require_relative '../models/role'
require_relative '../models/account'

# Define the role descriptions
role_descriptions = ['admin', 'teacher', 'staff', 'student']

# Iterate over the descriptions and create roles if they don't exist
role_descriptions.each do |desc|
  Todo::Role.find_or_create(name: desc)
end

admin_user_data = {
  "name": "..",
  "email": "..",
  "roles": [
    "admin"
    ],
  "sso_token": ".."
}

# Add a new account with the provided data
Todo::Account.add_account(admin_user_data)
