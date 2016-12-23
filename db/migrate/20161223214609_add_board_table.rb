class AddBoardTable < ActiveRecord::Migration[5.0]
  def change
    create_table :boards do |t|
      t.string :trello_id
      t.string :location
    end
  end
end
