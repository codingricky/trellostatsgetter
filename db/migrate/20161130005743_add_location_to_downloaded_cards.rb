class AddLocationToDownloadedCards < ActiveRecord::Migration[5.0]
  def change
    add_column :downloaded_cards, :location, :string
  end
end
