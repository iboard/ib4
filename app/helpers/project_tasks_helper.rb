module ProjectTasksHelper
  
  
  def show_project_task_in_project(project_task,my_filter)
    color = project_task.date_due && project_task.date_due < Time::now ? '#D41E0F' : '#4D4D4D'
    color = '#80AC00' if project_task.state?(:done)
    color = '#dddddd' if project_task.state?(:canceled)
    color = '#aaaaaa' if project_task.state?(:paused)
    color = '#215799' if project_task.state?(:new)
    bgcolor = cycle('#eeeeee','#E8E3CE')
    Markaby::Builder.new({},self) {
        li :id => 'project_task_'+project_task.id.to_s, :class => 'project_task', :style => 'padding-left: 5px; width: 99%; background:'+bgcolor do
          span :class => 'project_task_link' do
            link_to_remote( project_task.name,
             :url =>  project_project_task_path(project_task.project.id,project_task.id).to_s,
             :method => :get,
             :with => "project_id='#{project_task.project.id.to_s}'", :id=>"id='#{project_task.id.to_s}'",
             :complete => "Element.highlight('selected_task');"
             )
          end
          span :class => 'handle', :style => 'cursor:move;' do
            BR+'['+I18n.translate(:drag).to_s+']'+NBSP
          end
          span :title => 'date new/active/paused/done/canceled/count',
               :style => 'float: right; cursor:help; text-align:right; padding-left: 50px; color:'+color do
            (project_task.date_due ? (humanize_time_span(project_task.date_due)) : "")+
            (project_task.date_due ? NBSP : "")+
            project_task.complete_map.join("/")
          end
         if project_task.children.any?
           ol :id => 'children_sort_list_'+project_task.id.to_s do
             for child in project_task.children
               show_project_task_in_project(child,my_filter) if my_filter.blank? || project_task.state?(my_filter.to_sym)
             end
           end
           id_str = 'children_sort_list_'+project_task.id.to_s
           sortable_element(id_str, :url => sort_tasks_project_path(project,:list_id => id_str).to_s, :handle => 'handle' )           
         end
        end
    }.to_s
  end
  
  def show_project_tasks(project,id='project_task_sortlist',my_filter='',width='340px')
    Markaby::Builder.new({},self) do 
      if my_filter.blank?
        roots = project.project_tasks(:include=>[:children,:project],:conditions => ["project_tasks.parent_id = ?",nil]).reject { |t| !t.parent_id.nil? }
      else
        roots = project.project_tasks(:include=>[:children,:project],:conditions => ["project_tasks.parent_id = ?",nil]).reject { |t| !t.parent_id.nil? || !t.state?(my_filter.to_sym)}
      end
      if roots.any?
        ol :id => id, :style => "width: #{width}" do
          for project_task in roots
              show_project_task_in_project(project_task,'') if my_filter.blank? || project_task.state?(my_filter.to_sym)
          end 
        end
        sortable_element(id, :url => sort_tasks_project_path(project,:list_id => id).to_s, :handle => 'handle' )
      else
        ul I18n.translate(:no_item_found)
      end
    end
  end
  
  
  def selected_task_form(project,project_task)
    render( :partial => '/project_tasks/selected_task', :locals => { :project => project, :project_task => project_task }).to_s
  end
  
end
