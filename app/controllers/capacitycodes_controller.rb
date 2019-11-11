class CapacitycodesController < ApplicationController
  before_action :set_capacitycode, only: [:show, :edit, :update, :destroy]

  # GET /capacitycodes
  # GET /capacitycodes.json
  def index
    @capacitycodes = Capacitycode.all
  end

  # GET /capacitycodes/1
  # GET /capacitycodes/1.json
  def show
  end

  # GET /capacitycodes/new
  def new
    @capacitycode = Capacitycode.new
  end

  # GET /capacitycodes/1/edit
  def edit
  end

  # POST /capacitycodes
  # POST /capacitycodes.json
  def create
    @capacitycode = Capacitycode.new(capacitycode_params)
    redirect_to capacitycodes_path
  end

  # PATCH/PUT /capacitycodes/1
  # PATCH/PUT /capacitycodes/1.json
  def update
      @capacitycode.update(capacitycode_params)
      redirect_to capacitycodes_path
  end

  # DELETE /capacitycodes/1
  # DELETE /capacitycodes/1.json
  def destroy
    @capacitycode.destroy
    respond_to do |format|
      format.html { redirect_to capacitycodes_url, notice: 'Capacitycode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload_capcodes_file

    uploaded_io = params[:file]

    if uploaded_io.present?

      text = uploaded_io.read

      text.each_line do |line|
        line.gsub!("\r\n", '')
        values = line.split "\t"
        if Capacitycode.where("lower(text) = ?", values[1].downcase).count == 0
          capacitycode = Capacitycode.new
          capacitycode.capacity_number = values[0].to_i
          capacitycode.text = values[1]
          capacitycode.save
        end
      end
    end

    redirect_to capacitycodes_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_capacitycode
      @capacitycode = Capacitycode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def capacitycode_params
      params.require(:capacitycode).permit(:text, :capacity_number, :alert)
    end
end
