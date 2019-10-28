class AlterShotsAddUserId < ActiveRecord::Migration[5.2]
  def change
    add_column :shots, :user_id, :integer
    add_index :shots, :user_id
  end
end
