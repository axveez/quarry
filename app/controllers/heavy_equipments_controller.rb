class HeavyEquipmentsController < ApplicationController
  before_action :set_heavy_equipment, only: [:show, :edit, :update, :destroy]

  # GET /heavy_equipments
  # GET /heavy_equipments.json
  def index
    @heavy_equipments = HeavyEquipment.all
    @locations = Location.all
  end

  # GET /heavy_equipments/1
  # GET /heavy_equipments/1.json
  def show
    @locations = Location.all
  end

  # GET /heavy_equipments/new
  def new
    @heavy_equipment = HeavyEquipment.new
    @locations = Location.all
  end

  # GET /heavy_equipments/1/edit
  def edit
    @locations = Location.all
  end

  # POST /heavy_equipments
  # POST /heavy_equipments.json
  def create
    @heavy_equipment = HeavyEquipment.new(heavy_equipment_params)

    @locations = Location.all
    respond_to do |format|
      if @heavy_equipment.save
        format.html { redirect_to @heavy_equipment, notice: 'Heavy equipment was successfully created.' }
        format.json { render :show, status: :created, location: @heavy_equipment }
      else
        format.html { render :new }
        format.json { render json: @heavy_equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /heavy_equipments/1
  # PATCH/PUT /heavy_equipments/1.json
  def update
    @locations = Location.all
    respond_to do |format|
      if @heavy_equipment.update(heavy_equipment_params)
        format.html { redirect_to @heavy_equipment, notice: 'Heavy equipment was successfully updated.' }
        format.json { render :show, status: :ok, location: @heavy_equipment }
      else
        format.html { render :edit }
        format.json { render json: @heavy_equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /heavy_equipments/1
  # DELETE /heavy_equipments/1.json
  def destroy
    @locations = Location.all
    @heavy_equipment.destroy
    respond_to do |format|
      format.html { redirect_to heavy_equipments_url, notice: 'Heavy equipment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_heavy_equipment
      @heavy_equipment = HeavyEquipment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def heavy_equipment_params
      params.require(:heavy_equipment).permit(:machine_name, :stnk_number, :sio_number, :location_id)
    end
end
