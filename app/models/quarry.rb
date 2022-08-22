class Quarry < ApplicationRecord
  belongs_to :asset
  belongs_to :driver
  belongs_to :location

  def imageupload
    Gallery.where(:quarry_id=>self.id).count.to_i
  end
end
