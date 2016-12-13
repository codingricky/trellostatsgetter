class CreateLastUpdatedTime < ActiveRecord::Migration[5.0]
  def change
    create_table :last_updated_times do |t|
      t.datetime :time
    end
  end
end
