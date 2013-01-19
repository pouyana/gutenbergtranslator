roles = ['admin', 'user', 'reviewer']
existing_roles = Role.all.map { |r| r.name }
Role.delete(3)
roles.each do |role|
    Role.find_or_create_by_name({:name=> role}, :without_protection=>true)
end
