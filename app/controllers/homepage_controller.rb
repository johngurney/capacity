class HomepageController < ApplicationController

  def homepage
    if !check_if_admins_exist?
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
       users << {:user => user, :capacity_log => log, :capacity_number => (log.blank? ? 0 : log.capacity_number) } if user.user_type == "User" && user.check_search_criteria(@included_areas, @included_departments, @included_locations) && ((log.present? and log.absent) ^ !is_asbent) # ^ is xor
     end

     puts "Users " + users.count.to_s

     users.sort_by {|user| [user[:capacity_number], user[:user][:last_name], user[:user][:first_name]] }

  end

  def delete_all
    User.delete_all
    redirect_to root_path
  end

  def set_allow_cheat_logon
    $allow_cheatlogon = params[:cheat_logon] == "1"
    filename = Rails.root.join("public", "cheat_log_in")
    if $allow_cheatlogon
        File.open(filename, 'wb') do |file|
          file.write(1)
        end
      else
        File.delete(filename) if File.exist?(filename)
      end

    redirect_to root_path
  end


  def test

    Capacitylog.delete_all

    prng = Random.new
    date = Date.today
    capacity_number = 2

    (1..50).each do |n|

      if capacity_number >= 4
        capacity_number = 3
      elsif capacity_number <= 0
          capacity_number = 1
      else
        capacity_number += + rand(3) - 1
      end
      no_days = prng.rand(14).to_i + 2
      date -= no_days.days

      puts "Date = " + date.to_s

      log = Capacitylog.new
      log.created_at = date
      log.capacity_number = capacity_number
      log.user_id = 78
      log.absent = false
      log.save


    end
    redirect_to root_path


    # user = User.all.where(:last_name => "Tench").first
    # user.user_type = "Administrator"
    # user.save
    # redirect_to root_path
  end

  def search_aois
    if params[:commit] != "Search"
      redirect_to root_path
    else

      @included_areas = []
      flag = true
      Area.all.each do |area|
        if params["check_area" + area.id.to_s ] == "1"
          @included_areas << area.id
        else
          flag = false
        end
      end
      @included_areas = nil if flag #If all selected

      @included_departments = []
      flag = true
      Department.all.each do |department|
        if params["check_department" + department.id.to_s ] == "1"
          @included_departments << department.id
        else
          flag = false
        end
      end
      @included_departments = nil if flag #If all selected

      @included_locations = []
      flag = true
      Location.all.each do |location|
        if params["check_location" + location.id.to_s ] == "1"
          @included_locations << location.id
        else
          flag = false
        end
      end
      @included_locations = nil if flag #If all selected

      @non_absent_users = get_users(false)
      @absent_users = get_users(true)
      get_emails

    render "partner_homepage"
    end
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
