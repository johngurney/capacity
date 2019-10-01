class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :capacity_log]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

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
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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
        #user.password   = "test"
        if tel_number_column >= 0
          user.telephone   = values[tel_number_column]
        end

        if email_address_column >= 0
          user.email   = values[email_address_column]
        end
        user.save if User.where("lower(email) = ?", user.email).count == 0

      end
    end

    redirect_to users_path
  end

  def capacity_log

    log = Capacitylog.create(:user_id => @user.id, :capacity_number => params[:capacity_number].to_i, :comment => params[:text], :absent => params[:absent] == "1", :return_date => params[:return_date] )

    puts "***" + log.to_s
    redirect_to root_path

  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :user_type, :location, :position, :telephone, :email)
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
