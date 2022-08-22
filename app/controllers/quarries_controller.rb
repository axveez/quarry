class QuarriesController < ApplicationController
  before_action :set_quarry, only: [:show, :edit, :update, :destroy]

  # GET /quarries
  # GET /quarries.json
  def index
    if params[:record_id].present?
      cari_quarry = Quarry.find(params[:record_id])
      cari_quarry.update({
        :time_out=> DateTime.now()
      })
      a
      Log.create({
        :asset_id=> cari_quarry.asset_id,
        :driver_id=> cari_quarry.driver_id,
        :date=> cari_quarry.date,
        :activity=> "Keluar dari Quarry",
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

    @quarries = Quarry.where(:date=>session[:date])
  end

  # GET /quarries/1
  # GET /quarries/1.json
  def show
    @fleets = Fleet.where("time_in IS NULL")
    @locations = Location.all
  end

  # GET /quarries/new
  def new
    @quarry = Quarry.new
    @fleets = Fleet.where("time_in IS NULL")
    @locations = Location.all
  end

  # GET /quarries/1/edit
  def edit

    @fleets = Fleet.where("time_in IS NULL")
    @locations = Location.all
  end

  def time_out
    @quarry = Quarry.find(params[:id])
    @fleets = Fleet.where("time_in IS NULL")
    @locations = Location.all
    @gallery = Gallery.where(:quarry_id=>params[:id])
  end

  def upload
    @quarry = Quarry.find(params[:id])
    @fleets = Fleet.where("time_in IS NULL")
    @locations = Location.all
    @gallery = Gallery.where(:quarry_id=>params[:id])
  end

  # POST /quarries
  # POST /quarries.json
  def create
    @quarry = Quarry.new(quarry_params)

    respond_to do |format|
      if @quarry.save
        Log.create({
          :asset_id=> @quarry.asset_id,
          :driver_id=> @quarry.driver_id,
          :date=> @quarry.date,
          :activity=> "Masuk ke Quarry",
          :time=> @quarry.time_in,
          :created_at=> DateTime.now(),
          :updated_at=> DateTime.now()
        })

        format.html { redirect_to @quarry, notice: 'Quarry was successfully created.' }
        format.json { render :show, status: :created, location: @quarry }
      else
        format.html { render :new }
        format.json { render json: @quarry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quarries/1
  # PATCH/PUT /quarries/1.json
  def update
    if params['quarry'].present?
      if params['quarry']['time_out'].present?
        @backfill = Backfill.new({
           "asset_id"=>params['quarry']['asset_id'], 
           "driver_id"=>params['quarry']['driver_id'], 
           "cargo_leftover"=>params['quarry']['cargo_leftover'], 
           "date"=>params['quarry']['date'], 
           "location_id"=>params['quarry']['location_id'], 
           "time_in"=>nil, 
           "time_out"=>nil, 
           "quarry_out"=>params['quarry']['time_out'],
           "created_at"=>DateTime.now()
        })
        if @backfill.save
          Log.create({
            :asset_id=> @backfill.asset_id,
            :driver_id=> @backfill.driver_id,
            :date=> @backfill.date,
            :activity=> "Masuk ke Pengurukan",
            :time=> nil,
            :created_at=> DateTime.now(),
            :updated_at=> DateTime.now()
          })
        else

          puts @backfill.errors.full_messages
          if @backfill.errors.full_messages.present?
            error
          end

        end
      end
      respond_to do |format|
        if @quarry.update(quarry_params)
          format.html { redirect_to @quarry, notice: 'Quarry was successfully updated.' }
          format.json { render :show, status: :ok, location: @quarry }
        else
          format.html { render :edit }
          format.json { render json: @quarry.errors, status: :unprocessable_entity }
        end
      end
    end

    if params["upload"].present?
      if params["upload"]["file1"]
        content =  params["upload"]["file1"].read
        filename_original = params["upload"]["file1"].original_filename
        content_type = params["upload"]["file1"].content_type
        ext=File.extname(filename_original)    
        base64 = "data:#{content_type};base64,#{Base64.encode64(content)}"
        # puts base64
          cari = Gallery.find_by(:quarry_id=>params[:id],:type_photo=>"front")
          if cari.blank?
            Gallery.create({
              :quarry_id=>params[:id],
              :type_photo=>"front",
              :base64=>base64
            })
          else
            cari.update({
              :base64=>base64
            })
          end
        
      end
      
      if params["upload"]["file2"]
        content =  params["upload"]["file2"].read
        filename_original = params["upload"]["file2"].original_filename
        content_type = params["upload"]["file2"].content_type
        ext=File.extname(filename_original)  
        base64 = "data:#{content_type};base64,#{Base64.encode64(content)}"
        # puts base64
        cari = Gallery.find_by(:quarry_id=>params[:id],:type_photo=>"back")
        if cari.blank?
          Gallery.create({
            :quarry_id=>params[:id],
            :type_photo=>"back",
            :base64=>base64
          })
        else
          cari.update({
            :base64=>base64
          })
        end
        
        redirect_to "/quarries", notice: 'Image Uploaded'
      end

    
    end
  end

  # DELETE /quarries/1
  # DELETE /quarries/1.json
  def destroy
    @quarry.destroy
    respond_to do |format|
      format.html { redirect_to quarries_url, notice: 'Quarry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quarry
      @quarry = Quarry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quarry_params
      params.require(:quarry).permit(:asset_id, :driver_id, :date, :location_id, :time_in, :time_out,:cargo_leftover)
    end

end
