class Backfill < ApplicationRecord
  belongs_to :asset
  belongs_to :driver
  belongs_to :location
  def time_length
    if self.time_in.present? and self.quarry_out.present?
      gas = (self.time_in - self.quarry_out)
      jam = (gas/3600).to_i
      gas = gas - (jam*3600)
      menit = (gas/60).to_i
      gas = gas - (menit*60)
      detik = gas.to_i

      return "#{jam} Jam #{menit}  Menit #{detik} Detik"
    else
      return "Belum Masuk Pengurukan"
    end
  end
end
