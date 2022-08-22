class FleetsController < ApplicationController
  before_action :set_fleet, only: [:show, :edit, :update, :destroy]

  # GET /fleets
  # GET /fleets.json
  def index
    
    if params[:record_id].present?
      cari_fleet = Fleet.find(params[:record_id])
      cari_fleet.update({
        :time_in=> DateTime.now()
      })
      Asset.find(cari_fleet.asset_id).update({
          :status=> "idle"
      })
      Driver.find(cari_fleet.driver_id).update({
        :status=> "idle"
      })

      Log.create({
        :asset_id=> cari_fleet.asset_id,
        :driver_id=> cari_fleet.driver_id,
        :date=> cari_fleet.date,
        :activity=> "Masuk ke Armada",
        :time=> DateTime.now(),
        :created_at=> DateTime.now(),
        :updated_at=> DateTime.now()
      })

      redirect_to "/#{params[:controller]}"
    end

    if params[:date].present?
      session[:date] = params[:date]
      redirect_to "/#{params[:controller]}"
    end

    # @fleets = Fleet.where(:date=>session[:date]).order("time_out desc")
    @fleets = Fleet.order("time_out desc")
  end

  # GET /fleets/1
  # GET /fleets/1.json
  def show
    @assets = Asset.all
    @drivers = Driver.all
  end

  # GET /fleets/new
  def new
    @fleet = Fleet.new
    @assets = Asset.where(:status=>"idle")
    @drivers = Driver.where(:status=>"idle")
  end

  # GET /fleets/1/edit
  def edit
    @assets = Asset.all
    @drivers = Driver.all
  end

  # POST /fleets
  # POST /fleets.json
  def create
    @fleet = Fleet.new(fleet_params)
    respond_to do |format|
      if @fleet.save
        Asset.find(fleet_params["asset_id"]).update({
          :status=> "run"
        })
        Driver.find(fleet_params["driver_id"]).update({
          :status=> "working"
        })

        Log.create({
          :asset_id=> @fleet.asset_id,
          :driver_id=> @fleet.driver_id,
          :date=> @fleet.date,
          :activity=> "Keluar dari Armada",
          :time=> @fleet.time_out,
          :created_at=> DateTime.now(),
          :updated_at=> DateTime.now()
        })
        format.html { redirect_to @fleet, notice: 'Fleet was successfully created.' }
        format.json { render :show, status: :created, location: @fleet }
      else
        format.html { render :new }
        format.json { render json: @fleet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fleets/1
  # PATCH/PUT /fleets/1.json
  def update
    respond_to do |format|
      if @fleet.update(fleet_params)
        format.html { redirect_to @fleet, notice: 'Fleet was successfully updated.' }
        format.json { render :show, status: :ok, location: @fleet }
      else
        format.html { render :edit }
        format.json { render json: @fleet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fleets/1
  # DELETE /fleets/1.json
  def destroy
    @fleet.destroy
    respond_to do |format|

      Asset.find(@fleet.asset_id).update({
          :status=> "idle"
      })
      Driver.find(@fleet.driver_id).update({
        :status=> "idle"
      })

      format.html { redirect_to fleets_url, notice: 'Fleet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fleet
      @fleet = Fleet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fleet_params
      params.require(:fleet).permit(:asset_id, :driver_id, :date, :sim_check, :ktp_check, :stnk_check, :kir_check, :time_in, :time_out)
    end
end
