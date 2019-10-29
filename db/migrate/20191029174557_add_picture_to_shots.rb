class AddPictureToShots < ActiveRecord::Migration[5.2]
  def change
    add_column :shots, :picture, :string
  end
end
