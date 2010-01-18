# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# The User-Class uses AuthLogic

class User < ActiveRecord::Base
  
  acts_as_authentic
  
  has_attached_file :avatar, 
                    :styles => { 
                      :medium => "300x300>", :thumb => "100x100>", 
                      :avatar => "100x100#", :icon => "48x48#" 
                    }, 
                    :whiny_thumbnails => true
   
  has_many :postings,:dependent => :delete_all
  has_many :pages, :dependent => :delete_all
  has_many :comments, :dependent => :delete_all
  has_many :binaries, :dependent => :delete_all
  has_many :messages, :dependent => :delete_all
  has_many :message_notifications, :dependent => :delete_all
  has_many :project_memberships, :dependent => :delete_all
  has_many :projects, :through => :project_memberships
  
  has_many :sent_invitations,     :class_name => 'Invitation', :foreign_key => 'sender_id',     :dependent => :delete_all
  has_many :received_invitations, :class_name => 'Invitation', :foreign_key => 'recipient_id',  :dependent => :delete_all
  
  has_many :friendships, :dependent => :delete_all
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id', :dependent => :delete_all
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  
  has_many :notes, :dependent => :delete_all
  has_many :usergroups
  has_many :group_memberships, :dependent => :delete_all
  
  has_many :task_actions, :dependent => :delete_all, :order => :position
  has_many :action_contexts, :through => :task_actions
    
  accepts_nested_attributes_for :task_actions, :allow_destroy => true
  attr_accessible :username, :email, :password, :password_confirmation, :fullname, :avatar, :task_actions_attributes
  
  # Roles for declarative authorization
  def role_symbols
    if is_admin
      [:admin,:member] 
    else
      [:member] 
    end
  end
 
  def my_friends
    commited_friendships.map { |fs|
      [fs.friend, fs.user]
    }.flatten.uniq
  end
  
  # list all friends of your friendships-list when they found in inverse_friendships too
  def commited_friendships
    @commited_friendships ||= friendships.all.reject { |r|
                                inverse_friendships.find_by_user_id(r.friend_id).nil?
                              } + 
                              inverse_friendships.all.reject { |r| 
                                friendships.find_by_user_id(r.user_id).nil?
                              }
  end
  
  # list all friendships which are not found in inverse_friendships
  def not_commited_friendships
    @not_commited_friendships ||= friendships.all.reject { |r|
      ! inverse_friendships.find_by_user_id(r.friend_id).nil?
    }
  end
  
  # list friendships which you have not accepted yet
  def not_confirmed_friendships
    @not_confirmed_friendships ||= inverse_friendships.all.reject { |r|
      ! friendships.find_by_friend_id(r.user_id).nil?
    }
  end
 
  def display_name_and_user
    "#{fullname} (#{username})"
  end
  
  def is_admin?
    is_admin
  end

  def deliver_password_reset_instructions(subject)
    reset_perishable_token!  
    UserMailer.deliver_password_reset_instructions(self,subject)  
  end  
  
  def deliver_new_account_instructions(subject)
    reset_perishable_token!  
    UserMailer.deliver_new_account_instructions(self,subject)  
  end        
  
  def new_messages
    message_notifications.new_notifications.map { |n| n.message }
  end
  
  def kind_of_friend(other_user)
    my_friends.include?(other_user) ? :friend_user : :foreign_user
  end

  def project_notes
    new_notes = []
    for membership in  project_memberships
      if membership.project && membership.project.notes
        new_notes << membership.project.notes.find(:all,:conditions => ['message_type <> ? and updated_at >= ?', 'confirm_read',
            Authorization.current_user.last_login_at]).reject { |r|
            r.children.find(:first,:conditions => ['message_type = ? and user_id = ?', 'confirm_read', Authorization.current_user])
        }
      end
    end
    new_notes.flatten.sort! { |b,a| a.updated_at <=> b.updated_at }
  end  

  def latest_project_notes
    new_notes = []
    for membership in  project_memberships
      if membership.project && membership.project.notes
        new_notes << membership.project.notes.find(:all,:conditions => ['message_type <> ? and updated_at >= ? and updated_at > ?', 'confirm_read',
            Authorization.current_user.last_login_at, Time::now-1.week]).reject { |r|
            r.children.find(:first,:conditions => ['message_type = ? and user_id = ?', 'confirm_read', Authorization.current_user])
        }
      end
    end
    new_notes.flatten.sort! { |b,a| a.updated_at <=> b.updated_at }
  end

  def used_context_names
    action_contexts.find(:all,:order => :name).map { |a| a.name }.uniq
  end
 
  def project_tasks
    projects.map { |p|
      p.project_tasks(:order => :position).flatten
    }.flatten
  end  
end
