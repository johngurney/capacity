class ApplicationController < ActionController::Base

  before_action :check_cookie_consent, except: [:cookie_consent, :log_in, :contact_sheet, :cheat_log_in, :set_allow_cheat_logon, :set_objective, :reset_cookie_consent]
  before_action :check_logged_in, except: [:cookie_consent, :log_in, :contact_sheet, :cheat_log_in, :set_allow_cheat_logon, :set_objective, :reset_cookie_consent]
  before_action :check_admin, except: [:cookie_consent, :log_in, :contact_sheet, :cheat_log_in, :homepage, :show, :amend_aois, :capacity_log, :history, :selected_history, :set_allow_cheat_logon, :select_groups, :set_objective, :reset_cookie_consent]

  def check_cookie_consent
    if session[:cookie_consent].blank?
      if cookies[:cookie_consent].blank?
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

    if check_if_admins_exist?
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

  def check_if_admins_exist?
    User.all.count > 0 && User.where(:user_type => "Administrator").count > 0
  end


  def check_admin
    if logged_in_user_helper.present? && !logged_in_user_helper.is_admin? && check_if_admins_exist?
      redirect_to root_path
      false
    end

  end


  def telephone_link(tel_no)
      tel_no_mod = tel_no.to_s.scan(/(?:^\+)?\d+/)
      self.class.helpers.link_to tel_no, "#{tel_no_mod.join '-'}"
  end

  def logged_in_user_helper
    user = User.find(session[:logged_in_user]) if !session[:logged_in_user].blank? and User.exists?(id:  session[:logged_in_user].to_i)
    user
  end

  helper_method :telephone_link, :logged_in_user_helper

  def mobile?
    require "browser/aliases"
    Browser::Base.include(Browser::Aliases)
    @browser = Browser.new(request.env["HTTP_USER_AGENT"])
    @browser.mobile? #|| true
  end

end
