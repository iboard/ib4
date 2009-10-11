module UserSessionsHelper
  def current_locale
     session['locale'].to_sym
   end
end
