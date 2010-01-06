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
               td {Time.at(notes.first.parent.message_value.to_i).to_s(:short) }
               td {Time.at(notes.last.message_value.to_i).to_s(:short)}
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
  
end
