module UserSessionsHelper
  def current_locale
    session['locale'] || DEFAULT_LOCALE
  end
end
