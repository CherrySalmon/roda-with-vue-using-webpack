# db/seeds.rb

require_relative '../models/role'
require_relative '../models/permission'
require_relative '../models/granted_permission'

# Define the role descriptions
role_descriptions = ['admin', 'teacher', 'staff', 'student']

# Define permissions
permissions = [
  { name: 'accounts:view' },
  { name: 'accounts:modify' }
]

# Iterate over the descriptions and create roles if they don't exist
role_descriptions.each do |desc|
  Todo::Role.find_or_create(name: desc)
end

# Create permissions
permissions.each do |perm|
  Todo::Permission.find_or_create(perm)
end

# Assign 'View Account' and 'Modify Account' permissions to the 'admin' role
admin_role = Todo::Role.find(name: 'admin')

permissions.each do |perm|
  permission = Todo::Permission.find(name: perm[:name])
  Todo::GrantedPermission.find_or_create(role: admin_role, permission:)
end
