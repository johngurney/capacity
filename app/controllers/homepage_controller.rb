class HomepageController < ApplicationController

  def homepage
    if User.all.count == 0
      @non_absent_users = nil
      @absent_users = nil
      render 'homepage'
      return
    elsif logged_in_user_helper.blank?
      render 'user_homepage'
      return
    elsif logged_in_user_helper.user_type == "User"
      render 'user_homepage'
      return
    elsif logged_in_user_helper.user_type == "Partner"
      @non_absent_users = get_users(false)
      @absent_users = get_users(true)
      get_emails
      render 'partner_homepage'
      return
    end
    @non_absent_users = get_users(false)
    @absent_users = get_users(true)
    get_emails
  end

  def cookie_consent

    cookies.permanent[:capacity_cookie_consent] = true if params[:cookie_consent] == "1"
    redirect_to root_path
  end

  def log_in
    email = params[:email]
    if !email.blank?
      user = User.where(:email => email).first
      if !user.blank?
        if params[:password] == user.password
          cookies.permanent.signed[:logged_in_user] = user
          session[:logged_in_user] = user.id
          redirect_to root_path
          return
        end
      end
    end
    render 'general/password'

  end


  def reset_cookie_consent

    cookies.permanent[:contacts_cookie_consent] = nil
    redirect_to root_path

  end

  def log_out

    cookies.permanent[:logged_in_token] = nil
    session[:logged_in_user] = nil
    redirect_to root_path
  end

  def cheat_log_in

    user = User.find(params[:user].to_i)
    cookies.permanent[:logged_in_token] = user.login if !user.blank?
    session[:logged_in_user] = user.id
    redirect_to root_path

  end

  def get_users(is_asbent)
     users = []
     User.all.each do |user|
       log = user.capacity_log
       users << {:user => user, :capacity_log => log, :capacity_number => (log.blank? ? 0 : log.capacity_number) } if user.user_type == "User" && ((log.present? and log.absent) ^ !is_asbent) # ^ is xor
     end

     users.sort_by {|user| [user[:capacity_number], user[:user][:last_name], user[:user][:first_name]] }

  end



  def test
    User.all.each do |user|
      user.absent = false
      user.save
    end
    redirect_to root_path
  end

  private

  def get_emails
    @checkboxes = "["
    @emails = "["
    users = User.where(:user_type => "User")
    flag = false
    users.each do |user|
      if flag
        @checkboxes += ","
        @emails += ","
      else
        flag = true
      end
      @checkboxes += user.id.to_s
      @emails += "\"" + user.email + "\""
    end
    @checkboxes += "]"
    @emails += "]"

  end


end
