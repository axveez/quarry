class BackfillsController < ApplicationController
  before_action :set_backfill, only: [:show, :edit, :update, :destroy]

  # GET /backfills
  # GET /backfills.json
  def index
    
    if params[:record_id].present?
      case params[:type]
      when 'time_in'
        cari_backfill = Backfill.find(params[:record_id])
        cari_backfill.update({
          :time_in=> DateTime.now()
        })
        Log.create({
          :asset_id=> cari_backfill.asset_id,
          :driver_id=> cari_backfill.driver_id,
          :date=> cari_backfill.date,
          :activity=> "Masuk ke Pengurukan",
          :time=> DateTime.now(),
          :created_at=> DateTime.now(),
          :updated_at=> DateTime.now()
        })
      when 'time_out'
        cari_backfill = Backfill.find(params[:record_id])
        cari_backfill.update({
          :time_out=> DateTime.now()
        })
        Log.create({
          :asset_id=> cari_backfill.asset_id,
          :driver_id=> cari_backfill.driver_id,
          :date=> cari_backfill.date,
          :activity=> "Keluar dari Pengurukan",
          :time=> DateTime.now(),
          :created_at=> DateTime.now(),
          :updated_at=> DateTime.now()
        })
      end
      
      redirect_to "/#{params[:controller]}"
    end

    if params[:date].present?
      session[:date] = params[:date]
      redirect_to "/#{params[:controller]}"
    end

    @backfills = Backfill.where(:date=>session[:date])
  end

  # GET /backfills/1
  # GET /backfills/1.json
  def show
    @fleets = Fleet.where("time_in IS NULL")
    @locations = Location.all
  end

  # GET /backfills/new
  def new
    @backfill = Backfill.new
    @fleets = Fleet.where("time_in IS NULL")
    @locations = Location.all
  end

  # GET /backfills/1/edit
  def edit
    @fleets = Fleet.where("time_in IS NULL")
    @locations = Location.all
  end

  # POST /backfills
  # POST /backfills.json
  def create
    @backfill = Backfill.new(backfill_params)
    
    respond_to do |format|
      if @backfill.save
        Log.create({
          :asset_id=> @backfill.asset_id,
          :driver_id=> @backfill.driver_id,
          :date=> @backfill.date,
          :activity=> "Masuk ke Pengurukan",
          :time=> @backfill.time_in,
          :created_at=> DateTime.now(),
          :updated_at=> DateTime.now()
        })
        quarry_last_out(@backfill.id,@backfill.asset_id,@backfill.driver_id)
        format.html { redirect_to @backfill, notice: 'Backfill was successfully created.' }
        format.json { render :show, status: :created, location: @backfill }
      else
        format.html { render :new }
        format.json { render json: @backfill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /backfills/1
  # PATCH/PUT /backfills/1.json
  def update
    respond_to do |format|
      if @backfill.update(backfill_params)
        format.html { redirect_to @backfill, notice: 'Backfill was successfully updated.' }
        format.json { render :show, status: :ok, location: @backfill }
      else
        format.html { render :edit }
        format.json { render json: @backfill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /backfills/1
  # DELETE /backfills/1.json
  def destroy
    @backfill.destroy
    respond_to do |format|
      format.html { redirect_to backfills_url, notice: 'Backfill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_backfill
      @backfill = Backfill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def backfill_params
      params.require(:backfill).permit(:asset_id, :driver_id, :location_id, :date, :time_in, :time_out, :cargo_leftover)
    end

    def quarry_last_out(backfill_id,asset_id,driver_id)
      if backfill_id.present?
        quarry_out = Quarry.where(:asset_id=>asset_id,:driver_id=>driver_id).last.time_out 
        @backfill.update_columns({:quarry_out=> quarry_out})  
      end
    end
end
