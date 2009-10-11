module UserSessionsHelper
  def current_locale
    return session['locale'] unless session['locale'].blank?
    browservalue = request.env['HTTP_ACCEPT_LANGUAGE'] ? request.env['HTTP_ACCEPT_LANGUAGE'].gsub(/\-.*$/,"") : DEFAULT_LOCALE
    session['locale'] || browservalue
  end
end
