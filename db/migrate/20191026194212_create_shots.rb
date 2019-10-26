class CreateShots < ActiveRecord::Migration[5.2]
  def change
    create_table :shots do |t|
      t.text :message
      t.timestamps
    end
  end
end
