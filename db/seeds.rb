# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#
#  CREATE ROOT USER IF NO ADMIN USER EXISTS
#
root_users = User.find_all_by_is_admin(true)
if root_users.empty?
  puts "NO USER IS ADMIN CREATING USER root/secret CHANGE THIS PASSWORD ASAP!"
  root = User.create(
    :username => 'root', 
    :email => 'set@your.address.here', 
    :password => 'secret', 
    :password_confirmation => 'secret',
    :fullname => 'System Administrator'
  )
  root.is_admin = true
  if !root.save
    root.save!
    puts " ERROR SAVING USER root"
    puts "  " +root.errors.map{|e| e.to_s}.join("\n  ")
  end
else
  puts "Admins is/are: " + root_users.map(&:username).join(", ")
end


