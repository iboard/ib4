# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#
#  CREATE ROOT USER IF NO ADMIN USER EXISTS
#
@root = User.find_all_by_is_admin(true)
if @root.empty?
  puts "NO USER IS ADMIN CREATING USER root/secret CHANGE THIS PASSWORD ASAP!"
  @root = User.create(
    :username => 'root', 
    :email => 'set@your.address.here', 
    :password => 'secret', 
    :password_confirmation => 'secret',
    :fullname => 'System Administrator'
  )
  @root.is_admin = true
  if !@root.save
    @root.save!
    puts " ERROR SAVING USER root"
    puts "  " +@root.errors.map{|e| e.to_s}.join("\n  ")
  end
else
  puts "Admins is/are: " + @root.map(&:username).join(", ")
end


page = Page.first
if !page
  puts "Creating welcome page"
  page = Page.new
  page.title='Welcome'
  page.description='Do not delete the first page in database, this will be the page being displayed when "home" will be clicked by the user'
  page.body="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. "
  page.user_id=@root.id
  page.save!
else
  puts "Welcomepage exists and is titled #{page.title}"
end
  
  
