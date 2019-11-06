class HomepageController < ApplicationController

  def homepage
    if logged_in_user_helper.blank? || logged_in_user_helper.is_user?
      render mobile? ? 'user_mobile'  :'user_homepage'
      return
    end

    @non_absent_users = get_users(false)
    @absent_users = get_users(true)
    get_emails

    if logged_in_user_helper.user_type == "Partner" or mobile?
      render mobile? ? 'partner_mobile'  :'partner_homepage'
      return
    end

  end

  def history_all
    @users = get_users(false)
    @users.concat(get_users(true))


  end

  def cookie_consent

    cookies.permanent[:cookie_consent] = true if params[:cookie_consent] == "1"
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

  def ad_admin
    User.create(:first_name => "Admin", :last_name => "User", :user_type => "Administrator")
    redirect_to root_path

  end


  def reset_cookie_consent

    cookies.permanent[:cookie_consent] = nil
    session[:cookie_consent] = nil
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
     # User.all.each do |user|
     #   log = user.capacity_log
     #   users << {:user => user, :capacity_log => log, :capacity_number => (log.blank? ? 0 : log.capacity_number) } if user.user_type == "User" && user.check_search_criteria(@included_areas, @included_departments, @included_locations) && ((log.present? and log.absent) ^ !is_asbent) # ^ is xor
     # end

     user = logged_in_user_helper

     user.groups.each do |group|
       if user.selected(group)
         group.users.each do |user|
           log = user.capacity_log
           if user.is_user? && user.check_search_criteria(@included_areas, @included_departments, @included_locations) && ((log.present? and log.absent) ^ !is_asbent) # ^ is xor
             users << {:user => user, :capacity_log => log, :capacity_number => (log.blank? ? 0 : log.capacity_number) }
           end
         end
       end
     end

     users.uniq!

     users.sort_by {|user| [user[:capacity_number], user[:user][:last_name], user[:user][:first_name]] }

  end

  def delete_all
    User.delete_all
    redirect_to root_path
  end

  def set_allow_cheat_logon
    $allow_cheatlogon = params[:cheat_logon] == "1"
    write_delete_cheat_logon_file
    redirect_to root_path
  end


  def test

    # Area.all.each do |area|
    #   area.group_id = 1
    #   area.save
    # end

    # User.all.each do |user|
    #   if user.position == "Partner" && user.user_type == "User"
    #     user.user_type = "Partner"
    #     user.save
    #   end
    # end


    User.all.each do |user|

      prng = Random.new
      date = Date.today

      if user.is_user? && prng.rand(10) == 1
        puts "***" + user.name

        log = Capacitylog.where(:user_id => user.id).order(:created_at).last

        if log.present?

          return_date = date + prng.rand(14).to_i.days
          while return_date.saturday? || return_date.sunday?
            return_date += 1.days
          end

          log.return_date = return_date
          log.absent = true
          log.save
        end

      end
    end


    # Capacitylog.delete_all

    # User.all.each do |user|
    #
    #   prng = Random.new
    #   date = Date.today
    #   capacity_number = 3
    #
    #   (1..30).each do |n|
    #
    #     capacity_number += rand(3) - 1
    #
    #     if capacity_number > 4
    #       capacity_number = 4
    #     elsif capacity_number < 1
    #         capacity_number = 1
    #     end
    #
    #     no_days = prng.rand(14).to_i + 2
    #     date -= no_days.days
    #
    #     log = Capacitylog.new
    #     log.created_at = date
    #     log.capacity_number = capacity_number
    #     log.user_id = user.id
    #     log.absent = false
    #     log.save
    #
    #   end
    # end

    # User.all.each do |user|
    #   if user.user_type.blank?
    #     user.user_type = "User"
    #     user.save
    #   end
    #   if Capacitylog.where(:user_id => user.id).count == 0
    #     Capacitylog.create(:user_id => user.id, :capacity_number => 1, :absent => false)
    #   end
    # end

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
    flag = false
    [@absent_users, @non_absent_users].each do |users|
      users.each do |user|
        if flag
          @checkboxes += ","
          @emails += ","
        else
          flag = true
        end
        @checkboxes += user[:user].id.to_s
        @emails += "\"" + user[:user].email + "\""
      end
    end
    @checkboxes += "]"
    @emails += "]"

  end


end
