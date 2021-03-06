module NotesHelper
  
  
  def session_table(notes) 
    Markaby::Builder.new( {}, self ) do
       table.standard_table :cellpadding => 0, :cellspacing => 0 do
         tr.table_header do
           th { I18n.translate(:log_in)  }
           th { I18n.translate(:log_out) }
           th { I18n.translate(:message) }
           th { I18n.translate(:duration)}
         end
         for note in notes do
           tr :class => cycle(:odd,:even) do
             td { note.parent ? Time.at( note.parent.message_value.to_i).to_s(:short) : I18n.translate(:no_login_found) }
             td { Time.at( note.message_value.to_i ).to_s(:short) }
             td { note.message }
             td :align =>:right do
                if note.parent
                   ((note.message_value.to_i-note.parent.message_value.to_i)/60.0).round(2).to_s+"#{NBSP}min"
                else 
                  link_to I18n.translate(:destroy), note,:user_id => note.user, 
                    :confirm => I18n.translate(:are_you_sure,:what=> I18n.translate(:delete_item)), 
                    :method => :delete
                end
             end
           end
         end
         tr.table_header do
            th I18n.translate(:first_login)
            th I18n.translate(:last_logout)
            th :colspan => 2, :align => :right do 
              I18n.translate(:total_logged_in)
            end
         end
         tr do
           if notes.any?
             begin
               td {Time.at(notes.first.parent.message_value.to_i).to_s(:short) if notes.first.parent }
               td {Time.at(notes.last.message_value.to_i).to_s(:short)  if notes.last }
               td {notes.last.message}
               td :align=>:right do
                  (notes.sum { |note| 
                    note.parent ?  note.message_value.to_i-note.parent.message_value.to_i : 0 
                  }/60).to_s+" min"
               end
             rescue => e
               td { e.to_s }
             end
           else
              td :colspan => 4, :align => :center do
                I18n.translate(:no_history_available)
              end
           end
         end             
       end  
    end
  end
  
  def display_notes_for(notes)
    unique_types = notes.map { |n| n.noteable_type }.uniq
    if unique_types.length == 1
      render :partial => "/#{unique_types[0].downcase.pluralize}/notes", 
        :locals => { 
                     :notes => notes, 
                     :object_type => unique_types.first
                   }
    else
      render :partial => notes
    end
  end

  def user_project_notes(user)
    if user.latest_project_notes.any?
      Markaby::Builder.new({},self) do
        div.new_project_notes! do
          h3 I18n.translate(:project_activities)
          address :style => 'float: right; padding: 5px; background: white;' do
            link_to_remote( I18n.translate(:mark_all_read),
              :url => {
                :user_id => user,
                :controller => :notes,
                :action => 'mark_all_read'
              },
              :complete => "Element.blindUp('new_project_notes');"
            ).to_s
          end
          user.latest_project_notes.each do |note|
            div :id => 'note_'+note.id.to_s, :style=>"background: #{cycle('#EFE8C9', '#FFF9DA')};padding: 3px;" do
              link_to_remote( I18n.translate(:mark_read)+NBSP*3,
                :url => {
                  :id => note.id,
                  :user_id => user,
                  :controller => 'notes',
                  :action => 'mark_read'
                },
                :method => :put,
                :complete => "Element.fade('note_#{note.id}');"
              )
              b { I18n.translate(:new_project_note_with_project, :user =>  note.user.fullname, 
                :time => humanize_time_span(note.updated_at),
                :project => link_to(note.noteable.name, note.noteable ).to_s,
                :what => I18n.translate("message_type_"+note.message_type)) }
              blockquote do
                note.message
              end
            end
          end
        end
      end
    end
  end
  
end
