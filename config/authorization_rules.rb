authorization do
  
  role :admin do
    has_permission_on [:users], 
               :to => [:index,:show,:new,:create,:edit,:update,:destroy ]
  end
  
  role :member do
    has_permission_on :users, :to => [:index,:show,:new,:create,:edit,:update ] do
      if_attribute :id => is { Authorization.current_user.id }
    end
  end
  
  role :guest do
    has_permission_on :users, :to => [:new,:create]
  end
   
end