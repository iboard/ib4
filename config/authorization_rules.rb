authorization do
  
  role :admin do
    has_permission_on [:users], 
               :to => [:index,:show,:new,:create,:edit,:update,:destroy ]
    has_permission_on :pages, :to => [:index,:show,:new,:create,:edit,:update,:destroy ]
  end

  role :guest do
    has_permission_on :users, :to => [:new,:create]
    has_permission_on :pages, :to => [:index, :show]
  end

  
  role :member do
    includes :guest
    has_permission_on :users, :to => [:index,:show,:new,:create,:edit,:update ] do
      if_attribute :id => is { Authorization.current_user.id }
    end
    
    has_permission_on :pages, :to => [:new,:create]
    has_permission_on :pages, :to => [:edit,:update] do
      if_attribute :user => is { Authorization.current_user }
    end
  end
  
   
end