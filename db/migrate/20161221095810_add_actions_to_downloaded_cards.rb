class AddActionsToDownloadedCards < ActiveRecord::Migration[5.0]
  def change
    add_column :downloaded_cards, :actions, :data
  end
end
