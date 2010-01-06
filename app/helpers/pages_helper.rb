module PagesHelper
  
  
  def page_navigation(displayed_page)
    handle = is_admin? ? SORT_HANDLE : NBSP
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
              CAN_OPEN + NBSP + link_to(sibling.title,sibling)
            end
          end
          li do
            strong { CAN_OPEN+NBSP+(page.title || I18n.translate(:new_page)) }
          end
        end
      end
    end
  end
  
  def page_children_navigation(page)
    handle = is_admin? ? SORT_HANDLE : CAN_OPEN
    Markaby::Builder.new( {}, self ) do
      div.page_children_navigation! do
        if page.children.any?
          ul.page_children_navigation_list! do
            page.children.each do |page|
              if permitted_to?(:show,page)
                li :id => 'page_children_navigation_'+page.id.to_s do
                   "<span class='handle'>#{handle}</span>"+NBSP+link_to(page.title,page) 
                end
              end
            end
          end
        end
      end
    end
  end
  
  def list_children(page,header=nil)
    if page.children.any?
      Markaby::Builder.new( {}, self ) do
        div.page_children! do
          p { strong { header } } if header
          ul do
            page.children.each do |child|
              li { link_to child.title, child }
            end  
          end
        end
      end
    end
  end
  
  def list_siblings(page,header=nil)
    if page.siblings.any?
      Markaby::Builder.new( {}, self ) do
        div.page_siblings! do
          p { strong { header } } if header
          ul do
            page.siblings.each do |sibling|
              li { link_to sibling.title, sibling }
            end  
          end
        end
      end
    end
  end
  
  def interpret_body(txt)  /\[\[[\w|\s]+\]\]/
    i=100
    
    ## interpret children,title
    while i> 0 && txt.sub!( /\{\{children([,].*)\}\}/ ) { |param|
      list_children(@page,param.gsub(/[\{|\{|\}|\}|]/, "").gsub(/^children,/,"").strip)
    } do
      i -= 1
    end
    ## interpret children
    while i> 0 && txt.sub!( /\{\{children([,].*)*\}\}/ ) { |param|
      list_children(@page,t(:subpages))
    } do
      i -= 1
    end
    
    ## interpret siblings,title
    while i> 0 && txt.sub!( /\{\{siblings([,].*)\}\}/ ) { |param|
      list_siblings(@page,param.gsub(/[\{|\{|\}|\}|]/, "").gsub(/^siblings,/,"").strip)
    } do
      i -= 1
    end
    ## interpret siblings
    while i> 0 && txt.sub!( /\{\{siblings([,].*)*\}\}/ ) { |param|
      list_siblings(@page,t(:subpages))
    } do
      i -= 1
    end
    
    if i == 0
      txt += "<span style='color:red;'>LOOP BREAK AFTER 100 ITERATIONS</span>"
    end
    txt
  end

end
