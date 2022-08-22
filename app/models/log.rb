class Log < ApplicationRecord
  belongs_to :asset
  belongs_to :driver

  def count_turn
    Log.where(:asset_id=>self.asset_id,:driver_id=>self.driver_id,:activity=>"Keluar dari Pengurukan").count   
  end
end
