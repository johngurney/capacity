class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :capacity_log, :amend_aois, :make_password, :history, :selected_history, :amend_user_groups, :assign_groups, :set_objective]

  # GET /users
  # GET /users.json
  def index
    user = logged_in_user_helper
    @users = []
    user.groups.each do |group|
      @users.concat group.users if group.users.count > 0
    end
    @users.uniq!
    puts @users.to_s
    @users.sort_by! {|user| [user[:last_name], user[:first_name]] }

  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.department = Department.all.first
    @user.location = Location.all.first
    @user.user_type = "User"
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.update_attributes(user_params)
    @user.department = Department.find( params[:user][:department].to_i )
    @user.location = Location.find( params[:user][:location].to_i )

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    @user.update_attributes(user_params)
    @user.department = Department.find( params[:user][:department].to_i ) if params[:user][:department].to_i > 0
    @user.location = Location.find( params[:user][:location].to_i ) if params[:user][:location].to_i > 0
    @user.save
    redirect_to @user

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  def upload_users_file

    uploaded_io = params[:file]

    if uploaded_io.present?
      text = uploaded_io.read

      flag = false
      first_name_column = -1
      last_name_column = -1
      position_column = -1
      tel_number_column = -1
      mobile_number_column = -1
      email_address_column = -1

      text.each_line do |line|
        line.gsub!("\r\n", '')

        values=line.split "\t"
        if flag == false
          puts values.to_s
          first_name_column = find_in_array(values, "first_name")
          last_name_column = find_in_array(values, "last_name")
          position_column = find_in_array(values, "position")
          tel_number_column = find_in_array(values, "tel_number")
          email_address_column = find_in_array(values, "email_address")
          flag=true
        else

          user = User.new
          if first_name_column >= 0
            user.first_name = values[first_name_column]
          end
          if last_name_column >= 0
            user.last_name  = values[last_name_column]
          end
          if position_column >= 0
            user.position   = values[position_column]
          end

          if tel_number_column >= 0
            user.telephone   = values[tel_number_column]
          end

          if email_address_column >= 0
            user.email   = values[email_address_column]
          end

          user.user_type = "User"

          user.save if User.where("lower(email) = ?", user.email.downcase).count == 0
        end

      end
    end

    redirect_to users_path
  end

  def capacity_log

    log = Capacitylog.create(:user_id => @user.id, :capacity_number => params[:capacity_number].to_i, :comment => params[:text], :absent => params[:absent] == "1", :return_date => params[:return_date] )

    puts "***" + log.to_s
    redirect_to root_path

  end

  def amend_aois
    if params[:commit] == "Add area(s)"
      Area.all.each do |area|
        @user.areas << area if params["checkadd" + area.id.to_s ] == "1"
      end

    elsif params[:commit] == "Remove area(s)"
      Area.all.each do |area|
        @user.areas.delete(area) if params["checkremove" + area.id.to_s ] == "1"
      end
    end
    redirect_to root_path
  end

  def passwords
  end


  def make_password
    @user.make_password
    redirect_to passwords_path
  end


  def make_all_passwords
    User.all.each do |user|
      user.make_password
    end
    redirect_to passwords_path
  end

  def history
    @user.history_start_date = Time.now if @user.history_start_date.blank?
    @user.history_end_date = @user.history_start_date.prev_year if @user.history_end_date.blank?
    @user.save
  end

  def selected_history
    user = logged_in_user_helper
    if params[:commit] == "Ok"
      user.history_start_date = Date.parse(params[:start_date])
      user.history_end_date = Date.parse(params[:end_date])
    else
      case params[:auto_history]
      when "Last year"
        user.history_start_date = 1.years.ago + 1.days
        user.history_end_date = Date.today
      when "Last six months"
        user.history_start_date = 6.months.ago + 1.days
        user.history_end_date = Date.today
      when "Last three months"
        user.history_start_date = 3.months.ago + 1.days
        user.history_end_date = Date.today
      when "Last month"
        user.history_start_date = 1.months.ago + 1.days
        user.history_end_date = Date.today
      when "Last financial year"
        user.history_start_date
        if Date.today.month > 5
          user.history_start_date = Date.new(Date.today.year - 1, 5, 1)
        else
          user.history_start_date = Date.new(Date.today.year - 2, 5, 1)
        end
        user.history_end_date = @user.history_start_date.next_year - 1
      end
    end
    user.save
    redirect_to history_path(@user)
  end

  def amend_user_groups

    if params[:commit] == "Add group(s)"
      Group.all.each do |group|
        @user.groups << group if params["checkadd" + group.id.to_s ] == "1"
      end

    elsif params[:commit] == "Remove group(s)"
      Group.all.each do |group|
        @user.groups.delete(group) if params["checkremove" + group.id.to_s ] == "1" && @user.groups.count > 1
      end
    end
    redirect_to edit_user_path(@user)
  end

  def assign_groups
    #This sets the groups to which the logged on user is assigned, that is the ones to which he or  she has access
    #This can be set only by the administrator

    Group.all.each do |group|
      if params["checkgroup" + group.id.to_s ] == "1"
        @user.groups << group if !user.groups.include?(group)
      else
        @user.groups.delete(group) << group if user.groups.include?(group) && user.groups.count > 1
      end
    end


    redirect_to reqest.referer #users_path
  end

  def select_groups
    #This sets the groups to which the logged on user has selected, that is the ones to which he or she views as any particiular time
    #This can be set by the users
    user = helpers.logged_in_user_helper

    user.groups.each do |group|
      puts "ground_id" + group.id.to_s + params["checkgroup" + group.id.to_s ].to_s
      lookup = Groupuserlookup.where(:user_id => user.id, :group_id => group.id).first
      lookup.selected = params["checkgroup" + group.id.to_s ] == "1"
      puts "ground_id" + lookup.selected.to_s
      lookup.save
    end

    # render "temp"

    redirect_to request.referer #users_path

  end

  def set_objective
    Objective.create(:text => params[:text], :user_id => @user.id)
    redirect_to root_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :user_type, :position, :telephone, :email)
    end

    def find_in_array(arry , text)
      a = arry.index{|v| v.downcase == text.downcase}
      if a.blank?
        -1
      else
        a
      end
    end

end
