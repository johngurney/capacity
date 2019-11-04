class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  # GET /departments
  # GET /departments.json
  def index
    @departments = Department.all
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)
    @department.group_id = logged_in_user_helper.first_selected_group.id

    @department.save

    redirect_to departments_path

  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: 'Department was successfully updated.' }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url, notice: 'Department was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def upload_file

    uploaded_io = params[:file]

    if uploaded_io.present?

      text = uploaded_io.read

      text.each_line do |line|
        line.gsub!("\r\n", '')
        if Department.where(:group_id => logged_in_user_helper.first_selected_group.id).where("lower(name) = ?", line.downcase).count == 0
          dept = Department.new
          dept.name = line
          dept.group_id = logged_in_user_helper.first_selected_group.id
          dept.save
        end
      end
    end

    redirect_to departments_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:name)
    end
end
