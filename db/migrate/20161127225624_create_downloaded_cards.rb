class CreateDownloadedCards < ActiveRecord::Migration[5.0]
  def change
    create_table :downloaded_cards do |t|
      t.string :name
    end
  end
end
