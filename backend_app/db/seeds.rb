# db/seeds.rb

require_relative '../models/role'
require_relative '../models/permission'
require_relative '../models/granted_permission'

# Define the role descriptions
role_descriptions = ['admin', 'teacher', 'staff', 'student']

# Iterate over the descriptions and create roles if they don't exist
role_descriptions.each do |desc|
  Todo::Role.find_or_create(name: desc)
end

# Define permissions with corresponding roles
permissions = {
  admin: [
    { name: 'accounts:view' },
    { name: 'accounts:modify' }
  ],
  teacher: [
    { name: 'course:view' },
    { name: 'course:modify' }
  ]
}

# Iterate over the permissions hash to create roles and assign permissions
permissions.each do |role_name, perms|
  # Find or create the role
  role = Todo::Role.find_or_create(name: role_name.to_s)

  # Iterate over each permission for the role
  perms.each do |perm|
    # Find or create the permission
    permission = Todo::Permission.find_or_create(perm)

    # Find or create the granted permission linking the role to the permission
    Todo::GrantedPermission.find_or_create(role: role, permission: permission)
  end
end
