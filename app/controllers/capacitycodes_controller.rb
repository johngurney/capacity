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

    respond_to do |format|
      if @capacitycode.save
        format.html { redirect_to @capacitycode, notice: 'Capacitycode was successfully created.' }
        format.json { render :show, status: :created, location: @capacitycode }
      else
        format.html { render :new }
        format.json { render json: @capacitycode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /capacitycodes/1
  # PATCH/PUT /capacitycodes/1.json
  def update
    respond_to do |format|
      if @capacitycode.update(capacitycode_params)
        format.html { redirect_to @capacitycode, notice: 'Capacitycode was successfully updated.' }
        format.json { render :show, status: :ok, location: @capacitycode }
      else
        format.html { render :edit }
        format.json { render json: @capacitycode.errors, status: :unprocessable_entity }
      end
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_capacitycode
      @capacitycode = Capacitycode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def capacitycode_params
      params.require(:capacitycode).permit(:text, :number)
    end
end
