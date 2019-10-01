class CapacitylogsController < ApplicationController
  before_action :set_capacitylog, only: [:show, :edit, :update, :destroy]

  # GET /capacitylogs
  # GET /capacitylogs.json
  def index
    @capacitylogs = Capacitylog.all
  end

  # GET /capacitylogs/1
  # GET /capacitylogs/1.json
  def show
  end

  # GET /capacitylogs/new
  def new
    @capacitylog = Capacitylog.new
  end

  # GET /capacitylogs/1/edit
  def edit
  end

  # POST /capacitylogs
  # POST /capacitylogs.json
  def create
    @capacitylog = Capacitylog.new(capacitylog_params)

    respond_to do |format|
      if @capacitylog.save
        format.html { redirect_to @capacitylog, notice: 'Capacitylog was successfully created.' }
        format.json { render :show, status: :created, location: @capacitylog }
      else
        format.html { render :new }
        format.json { render json: @capacitylog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /capacitylogs/1
  # PATCH/PUT /capacitylogs/1.json
  def update
    respond_to do |format|
      if @capacitylog.update(capacitylog_params)
        format.html { redirect_to @capacitylog, notice: 'Capacitylog was successfully updated.' }
        format.json { render :show, status: :ok, location: @capacitylog }
      else
        format.html { render :edit }
        format.json { render json: @capacitylog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /capacitylogs/1
  # DELETE /capacitylogs/1.json
  def destroy
    @capacitylog.destroy
    respond_to do |format|
      format.html { redirect_to capacitylogs_url, notice: 'Capacitylog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_capacitylog
      @capacitylog = Capacitylog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def capacitylog_params
      params.require(:capacitylog).permit(:user_id, :comment, :capacitycode)
    end
end
