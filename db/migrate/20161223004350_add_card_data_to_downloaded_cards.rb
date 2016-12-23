class AddCardDataToDownloadedCards < ActiveRecord::Migration[5.0]
  def change
    add_column :downloaded_cards, :card_json, :json
  end
end
