module PagesHelper
  
  
  def page_navigation
    handle = is_admin? ? SORT_HANDLE : CAN_OPEN
    Markaby::Builder.new( {}, self ) do
      div.page_navigation! do
        ul.page_navigation_list! do
          Page.roots.each do |page|
            if permitted_to?(:show,page)
              if current_page?(page)
                li( :id => 'page_navigation_'+page.id.to_s) do
                  "<span class='handle'>#{handle}</span>"+ NBSP + b { page.title } 
                end
              else
                li( :id => 'page_navigation_'+page.id.to_s )do
                   "<span class='handle'>#{handle}</span>"+ NBSP + link_to(page.title,page) 
                end
              end
            end
          end
        end
      end
      br(:clear => :left)
    end
  end
  
  def page_subnavigation(page)
    handle = is_admin? ? SORT_HANDLE : CAN_OPEN
    Markaby::Builder.new( {}, self ) do
      div.page_subnavigation! do
        ul.page_subnavigation_list! do
          if page.parent
            li( :id => 'page_subnavigation_'+page.id.to_s ) do
              "<span class='handle'>#{handle}</span>"+NBSP+link_to(page.parent.title,page.parent)
            end
          else
            li( :id => 'page_subnavigation_'+page.id.to_s ) do
              page.title
            end
          end
          if page.children.any?          
            page.children.each do |page|
              if permitted_to?(:show,page)
                li :id => 'page_subnavigation_'+page.id.to_s do
                   "<span class='handle'>#{handle}</span>"+NBSP+link_to(page.title,page) 
                end
              end
            end
          end
        end
      end
    end
  end
  
end
