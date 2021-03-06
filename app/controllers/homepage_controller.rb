class HomepageController < ApplicationController

  def homepage
    if logged_in_user_helper.blank? || logged_in_user_helper.is_user?
      render mobile? ? 'user_mobile'  :'user_homepage'
      return
    end

    @non_absent_users = get_users(false)
    @absent_users = get_users(true)
    get_emails

    if logged_in_user_helper.is_observer? or mobile?
      render mobile? ? 'observer_mobile'  :'observer_homepage'
      return
    end

  end

  def history_all_select_users
    @flag = true
    history_all
  end


  def history_all
    @users = []
    get_users(false, true).each do |user|
      @users << user[:user]
    end
    get_users(true, true).each do |user|
      @users << user[:user]
    end

    @deselected_users = []

    if @flag
      @users.each do |user|
        puts "user" + user.id.to_s
        @deselected_users << user if params["checkuser" + user.id.to_s] != "1"
      end
    end

    render "history_all"

  end

  def cookie_consent

    cookies.permanent[:cookie_consent] = true if params[:cookie_consent] == "1"
    redirect_to root_path
  end

  def log_in
    email = params[:email].downcase
    if !email.blank?
      user = nil
      User.all.each do |user1|
        if user1.email.downcase == email
          user = user1
          break
        end
      end
      if !user.blank?
        if user.password == params[:password]
          cookies.permanent[:logged_in_token] = user.login if !user.blank?
          session[:logged_in_user] = user.id
          redirect_to root_path
          return
        end
      end
    end
    render 'general/password'

  end

  def ad_admin
    create_administrator
    redirect_to root_path

  end


  def reset_cookie_consent

    cookies.permanent[:cookie_consent] = nil
    session[:cookie_consent] = nil
    redirect_to root_path

  end

  def log_out

    Loginlog.where(:token => cookies.permanent[:logged_in_token].to_s).delete_all
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

  def get_users(is_asbent, include_leavers = false)
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
           if user.is_user? && (include_leavers || !user.has_left) && user.check_search_criteria(@included_areas, @included_departments, @included_locations) && ((log.present? and log.absent) ^ !is_asbent) # ^ is xor
             users << {:user => user, :capacity_log => log, :capacity_number => (log.blank? ? 0 : log.capacity_number) }
           end
         end
       end
     end

     users.uniq!

     users.sort_by {|user| [user[:capacity_number], user[:user][:alpha_order]] }

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

    # User.all.each do |user|
    #
    #   lit_group = Group.where(:name => "Litigation").first
    #
    #   puts "***" + user.user_type
    #   user.groups << lit_group if user.groups.count == 0
    #
    #   if user.user_type == "Partner" ||  (user.position.present? && user.position.downcase.include?("partner") && user.user_type != "Administrator")
    #     user.set_selected(lit_group,true) if !user.selected(lit_group)
    #     user.user_type = "Observer"
    #     puts "+++" + user.user_type
    #     user.save
    #   end
    # end

    # User.all.each do |user|
    #   user.email = user.email.to_s
    #   user.first_name = user.first_name.to_s
    #   user.last_name = user.last_name.to_s
    #   user.save
    # end
    stg = encrypt("Dan")


    t = Time.now
    # (1..58).each do
    #     stg1 = decrypt(stg)
    # end

    #
    User.all.order(:alpha_order).each do |user|
      stg = user.name
    end

    @t_elapsed = Time.now - t


    # Area.all.each do |area|
    #   area.group_id = 1
    #   area.save
    # end



    # User.all.each do |user|
    #
    #   if user.is_user?
    #
    #     prng = Random.new
    #     date = Date.today
    #
    #     if user.is_user? && prng.rand(10) == 1
    #       puts "***" + user.name
    #
    #       log = Capacitylog.where(:user_id => user.id).order(:created_at).last
    #
    #       if log.present?
    #
    #         return_date = date + prng.rand(14).to_i.days
    #         while return_date.saturday? || return_date.sunday?
    #           return_date += 1.days
    #         end
    #
    #         log.return_date = return_date
    #         log.absent = true
    #         log.save
    #       end
    #
    #     end
    #   end
    # end


    # Capacitylog.delete_all
    #
    # User.all.each do |user|
    #   if user.is_user?
    #
    #     prng = Random.new
    #     date = 2.years.ago + (prng.rand(5) == 1 ? prng.rand(600).days : 0.days)
    #     capacity_number = 3
    #
    #     while date < Date.today
    #
    #       capacity_number += rand(3) - 1
    #
    #       if capacity_number > 4
    #         capacity_number = 4
    #       elsif capacity_number < 1
    #           capacity_number = 1
    #       end
    #
    #       log = Capacitylog.new
    #       log.created_at = date
    #       log.capacity_number = capacity_number
    #       log.user_id = user.id
    #       log.absent = false
    #       log.save
    #
    #       no_days = prng.rand(14).to_i + 2
    #       date += no_days.days
    #
    #     end
    #
    #     if prng.rand(7) == 1
    #
    #       log = Capacitylog.where(:user_id => user.id).order(:created_at).last
    #
    #       if log.present?
    #
    #         return_date = date + prng.rand(14).to_i.days
    #         while return_date.saturday? || return_date.sunday?
    #           return_date += 1.days
    #         end
    #
    #         log.return_date = return_date
    #         log.absent = true
    #         log.save
    #       end
    #
    #     end


      # end
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

    render "temp" #, :layout => false

    # redirect_to root_path


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


    render "observer_homepage"
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
