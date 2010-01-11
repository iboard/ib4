authorization do
  
  
  role :admin do
    has_permission_on [:users], :to => [:index,:show,:new,:create,:edit,:update,:destroy ]
    has_permission_on :pages, :to => [:index,:show,:new,:create,:edit,:update,:destroy,:sort_roots,:sort_children]
    has_permission_on :binaries, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
    has_permission_on :postings, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
    has_permission_on :comments, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
    has_permission_on :messages, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
    has_permission_on :usergroups, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
    has_permission_on :categories, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
    has_permission_on :projects, :to => [:index,:show,:new,:create,:edit,:update,:destroy,:notes,:sort_tasks]
    has_permission_on :project_tasks, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
    has_permission_on :notes, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
  end

  role :guest do
    has_permission_on :users, :to => [:new,:create]
    has_permission_on :pages, :to => [:index,:show] do
      if_attribute( :allowed_users =>  is { true } ) 
    end
    has_permission_on :binaries, :to => [:show] do 
      if_attribute :access_roles =>  contains {  'public' }
    end
    has_permission_on :projects, :to => [:show,:activity_notes] do 
        if_attribute :access_roles =>  contains {  'public' }
    end
    has_permission_on :postings, :to => [:index,:show] do
      if_attribute :allowed_users => is { true }
    end
    has_permission_on :comments, :to => [:index,:show] do
      if_attribute :allowed_users => is { true }
    end
    has_permission_on :categories, :to => [:index,:show] do
      if_attribute :public => is { :true }
    end
  end

  
  role :member do
    includes :guest
    
    # USER
    has_permission_on :users, :to => [:index,:show,:join_group,:leave_group ] 
    has_permission_on :users, :to => [:index,:show,:new,:create,:edit,:update,:remove_avatar ] do
      if_attribute :id => is { Authorization.current_user.id }
    end
    
    #MESSAGES
    has_permission_on :messages, :to => [:index,:show,:new,:create,:edit,:update,:destroy ] do
      if_attribute :user => is { Authorization.current_user }
    end
    has_permission_on :messages, :to => [:new,:create] 
    has_permission_on :messages, :to => [:show ] do
      if_attribute :sending_allowed_to => is { Authorization.current_user }
    end
    
    # PAGE
    has_permission_on :pages, :to => [:new,:create]
    has_permission_on :pages, :to => [:edit,:update] do
      if_attribute :user => is { Authorization.current_user }
    end
    has_permission_on :pages, :to => [:show,:index] do
      if_attribute :allowed_users => contains { Authorization.current_user }
    end
    
    # POSTING
    has_permission_on :postings, :to => [:new,:create]
    has_permission_on :postings, :to => [:edit,:update,:destroy] do
      if_attribute :user => is { Authorization.current_user }
    end
    has_permission_on :postings, :to => [:show,:index] do
      if_attribute :allowed_users => contains { Authorization.current_user }
    end
    has_permission_on :pages, :to => [:show,:index] do
      if_attribute :user => is {  Authorization.current_user  }
    end
    
    # COMMENT
    has_permission_on :comments, :to => [:new,:create]
    has_permission_on :comments, :to => [:edit,:update,:destroy] do
      if_attribute :user => is { Authorization.current_user }
    end
    has_permission_on :comments, :to => [:show,:index] do
      if_attribute :allowed_users => contains { Authorization.current_user }
    end
    has_permission_on :comments, :to => [:show,:index] do
      if_attribute :user => is {  Authorization.current_user  }
    end
    
    # NOTES
    has_permission_on :notes, :to => [:edit,:update,:destroy] do
      if_attribute :user => is {  Authorization.current_user  }
    end
    has_permission_on :notes, :to => [:mark_read]    
    
    
    # BINARY
    has_permission_on :binaries, :to => [:show] do 
      if_attribute :access_roles => contains { 'public' }
      if_attribute :friends_access =>  contains {  Authorization.current_user }
    end
    has_permission_on :binaries, :to => [:index,:new,:create,:update,:destroy,:edit] do 
      if_attribute :user =>  is {  Authorization.current_user }
    end
    
    # PROJECTS
    has_permission_on :projects, :to => [:new,:create]
    has_permission_on :projects, :to => [:show,:notes] do 
      if_attribute :access_roles => contains { 'public' }
      if_attribute :members =>  contains {  Authorization.current_user }
    end
    has_permission_on :projects, :to => [:index,:new,:create,:update,:destroy,:edit,:sort_tasks] do 
      if_attribute :user =>  is {  Authorization.current_user }
    end
    
    # PROJECT_NOTES
    has_permission_on :projects, :to => [:index,:show,:new,:create,:update,:destroy,:edit] do 
      if_attribute :members =>  is {  Authorization.current_user }
    end
    
    
    # Usergroups
    has_permission_on :usergroups, :to => [:index,:new,:create,:show] 
    has_permission_on :usergroups, :to => [:update,:edit,:destroy] do
      if_attribute :user => is { Authorization.current_user } 
    end
    
  end
  
   
end