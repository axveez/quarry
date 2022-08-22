json.extract! fleet, :id, :asset_id, :driver_id, :date, :sim_check, :ktp_check, :stnk_check, :kir_check, :time_in, :time_out, :created_at, :updated_at
json.url fleet_url(fleet, format: :json)
