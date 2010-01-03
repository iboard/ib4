module PagesHelper
  
  
  def page_navigation
    Markaby::Builder.new( {}, self ) do
      div.page_navigation! do
        ul do
          Page.roots.each do |page|
            if permitted_to?(:show,page)
              if current_page?(page)
                li { CAN_OPEN + NBSP + b { page.title } }
              else
                li { CAN_OPEN + NBSP + link_to(page.title,page) }
              end
            end
          end
        end
      end
      br(:clear => :left)
    end
  end
  
  def page_subnavigation(page)
    Markaby::Builder.new( {}, self ) do
      div.page_subnavigation! do
        ul do
          if page.parent
            li {  '|'+NBSP+link_to(page.parent.title,page.parent) }
          else
            li { page.title }
          end
          if page.children.any?          
            page.children.each do |page|
              if permitted_to?(:show,page)
                li { '|'+NBSP+link_to(page.title,page) }
              end
            end
          end
        end
      end
    end
  end
  
end
