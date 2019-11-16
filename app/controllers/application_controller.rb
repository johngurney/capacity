class ApplicationController < ActionController::Base

  before_action :check_cookie_consent, except: [:test, :cookie_consent, :log_in, :contact_sheet, :cheat_log_in, :set_allow_cheat_logon, :set_objective, :reset_cookie_consent]
  before_action :check_logged_in, except: [:test, :cookie_consent, :log_in, :log_out, :contact_sheet, :cheat_log_in, :set_allow_cheat_logon, :set_objective, :reset_cookie_consent]
  before_action :check_admin, except: [:test, :cookie_consent, :log_in, :log_out, :contact_sheet, :cheat_log_in, :homepage, :show, :search_aois, :amend_aois, :capacity_log, :history, :selected_history, :history_all, :set_allow_cheat_logon, :select_groups, :set_objective, :reset_cookie_consent]

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

    create_default_user if !check_if_admins_exist?

    #Check in case user deleted during session
    session[:logged_in_user] = nil if !session[:logged_in_user].blank? && !User.exists?(id: session[:logged_in_user].to_i)

    if session[:logged_in_user].blank?
      puts "*********" + cookies[:logged_in_token]
      log = Loginlog.where(:token => cookies[:logged_in_token].to_s).first
      if cookies[:logged_in_token].blank? or log.blank? or !User.exists?(id:log.user_id)
        render 'general/password'
        false
      else
        session[:logged_in_user] = log.user_id
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
  end

  def create_default_user
    user = User.create(:first_name => "Admin", :last_name => "User", :user_type => "Administrator")
    session[:logged_in_user] = user.id
    default_group = Group.all.first
    update_administrators_with_groups
    user.set_selected(default_group, true)


    $allow_cheatlogon = true
    write_delete_cheat_logon_file


  end

  def write_delete_cheat_logon_file

    filename = Rails.root.join("public", "cheat_log_in")
    if $allow_cheatlogon
        File.open(filename, 'wb') do |file|
          file.write(1)
        end
      else
        File.delete(filename) if File.exist?(filename)
      end

  end

  def update_administrators_with_groups
    User.where(:user_type => "Administrator").each do |user|
      user.check_groups
    end
  end


  helper_method :telephone_link, :logged_in_user_helper

  def mobile?
    require "browser/aliases"
    Browser::Base.include(Browser::Aliases)
    @browser = Browser.new(request.env["HTTP_USER_AGENT"])
    @browser.mobile? #|| true
  end

  def alphasort_users
    users = []
    User.all.each do |user|
      users << {:id => user.id, :first_name => user.first_name, :last_name => user.last_name}
    end

    users.sort_by! {|user| [user[:last_name], user[:first_name]]}
    n = 1

    users.each  do |user|
      User.update(user[:id], :alpha_order => n)
      puts n.to_s + " - " + user[:last_name] + ": " + user[:id].to_s
      n += 1
    end
  end

  def create_administrator
    user = User.new
    user.first_name = "Admin"
    user.last_name = "User"
    user.user_type = "Administrator"
    user.email = ""
    user.save
  end


  def encrypt(unencrypted_content)
    make_crypt
    @crypt.encrypt_and_sign(unencrypted_content)
  end

  def decrypt(encrypted_content)
    make_crypt
    @crypt.decrypt_and_verify(encrypted_content)
  end

  def make_crypt
    if @crypt.blank?
      key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key Rails.configuration.encryption_salt, Rails.configuration.encryption_key_length
      @crypt = ActiveSupport::MessageEncryptor.new(key)
    end

  end


end
