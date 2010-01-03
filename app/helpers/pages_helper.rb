module PagesHelper
  
  
  def page_navigation(displayed_page)
    handle = is_admin? ? SORT_HANDLE : CAN_OPEN
    Markaby::Builder.new( {}, self ) do
      div.page_navigation! do
        ul.page_navigation_list! do
          Page.roots.each do |page|
            if permitted_to?(:show,page)
              if current_page?(page) || (displayed_page && displayed_page.ancestors.include?(page))
                li( :id => 'page_navigation_'+page.id.to_s) do
                  "<span class='handle'>#{handle}</span>"+ NBSP + b { link_to(page.title,page) } 
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
        ul.page_prefix_navigation do
          page.ancestors.reverse.each do |sibling|
            li do
              CAN_OPEN + NBSP + link_to(sibling.title,page.parent)
            end
          end
          li do
            strong { CAN_OPEN+NBSP+page.title }
          end
        end
        if page.children.any?
          br(:clear => :left)
          ul.page_subnavigation_list! do
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
