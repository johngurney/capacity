class AreasController < ApplicationController
  before_action :set_area, only: [:show, :edit, :update, :destroy]

  # GET /areas
  # GET /areas.json
  def index
    @areas = Area.all
  end

  # GET /areas/1
  # GET /areas/1.json
  def show
  end

  # GET /areas/new
  def new
    @area = Area.new
  end

  # GET /areas/1/edit
  def edit
  end

  # POST /areas
  # POST /areas.json
  def create

    @area = Area.new(area_params)
    @aresa.group_id = logged_in_user_helper.first_selected_group.id
    @area.save

    redirect_to areas_path
  end

  # PATCH/PUT /areas/1
  # PATCH/PUT /areas/1.json
  def update
    respond_to do |format|
      if @area.update(area_params)
        format.html { redirect_to @area, notice: 'Area was successfully updated.' }
        format.json { render :show, status: :ok, location: @area }
      else
        format.html { render :edit }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    @area.destroy
    respond_to do |format|
      format.html { redirect_to areas_url, notice: 'Area was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload_areas_file

    uploaded_io = params[:file]

    if uploaded_io.present?

      text = uploaded_io.read

      text.each_line do |line|
        line.gsub!("\r\n", '')
        if Area.where("lower(name) = ?", line.downcase).count == 0
          area = Area.new
          area.name = line
          area.group_id = logged_in_user_helper.first_selected_group.id
          area.save
        end
      end
    end

    redirect_to areas_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def area_params
      params.require(:area).permit(:name)
    end
end
