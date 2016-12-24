class AddHiredLanesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :hired_lanes do |t|
      t.string :name
    end
  end
end
