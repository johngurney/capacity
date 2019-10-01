class ApplicationController < ActionController::Base

  before_action :check_cookie_consent, except: [:cookie_consent, :log_in, :contact_sheet, :cheat_log_in ]
  before_action :check_logged_in, except: [:cookie_consent, :log_in, :contact_sheet, :cheat_log_in]

  def check_cookie_consent
    if session[:cookie_consent].blank?
      if cookies[:capacity_cookie_consent].blank?
        render 'general/cookie_consent'
        false
      else
        session[:cookie_consent] = true
      end
    end
  end

  def check_logged_in

    #Check in case user deleted during session
    session[:logged_in_user] = nil if !session[:logged_in_user].blank? && !User.exists?(id: session[:logged_in_user].to_i)

    if User.all.count >0

      if session[:logged_in_user].blank?
        if cookies[:logged_in_token].blank? or ( ( (log_in_logs = Loginlog.where(:token => cookies[:logged_in_token])).count == 0 ) or !User.exists?(id: log_in_logs.first.user_id) )
          render 'general/password'
          false
        else
          session[:logged_in_user] = log_in_logs.first.user_id
        end
      end
    end
  end


  def telephone_link(tel_no)
      tel_no_mod = tel_no.to_s.scan(/(?:^\+)?\d+/)
      self.class.helpers.link_to tel_no, "#{tel_no_mod.join '-'}"
  end

  def logged_in_user_helper
    user = User.find(session[:logged_in_user]) if !session[:logged_in_user].blank? and User.exists?(id:  session[:logged_in_user].to_i)
    puts "User =" + user.to_s
    user
  end

  helper_method :telephone_link, :logged_in_user_helper

  def mobile?
    require "browser/aliases"
    Browser::Base.include(Browser::Aliases)
    @browser = Browser.new(request.env["HTTP_USER_AGENT"])
    @browser.mobile?
  end

end
