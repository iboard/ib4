authorization do
  
  
  role :admin do
    has_permission_on [:users], :to => [:index,:show,:new,:create,:edit,:update,:destroy ]
    has_permission_on :pages, :to => [:index,:show,:new,:create,:edit,:update,:destroy ]
    has_permission_on :binaries, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
    has_permission_on :postings, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
    has_permission_on :messages, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
    has_permission_on :usergroups, :to => [:index,:show,:new,:create,:edit,:update,:destroy]
  end

  role :guest do
    has_permission_on :users, :to => [:new,:create]
    has_permission_on :pages, :to => [:index,:show] do
      if_attribute( :allowed_users =>  is { true } ) 
    end
    has_permission_on :binaries, :to => [:show] do 
      if_attribute :access_roles =>  contains {  'public' }
    end
    has_permission_on :postings, :to => [:index,:show] do
      if_attribute :allowed_users => is { true }
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
    
    # BINARY
    has_permission_on :binaries, :to => [:show] do 
      if_attribute :access_roles => contains { 'public' }
      if_attribute :friends_access =>  contains {  Authorization.current_user }
    end
      
    has_permission_on :binaries, :to => [:index,:new,:create,:update,:destroy,:edit] do 
      if_attribute :user =>  is {  Authorization.current_user }
    end

    # Usergroups
    has_permission_on :usergroups, :to => [:index,:new,:create,:show] 
    has_permission_on :usergroups, :to => [:update,:edit,:destroy] do
      if_attribute :user => is { Authorization.current_user } 
    end
    
  end
  
   
end