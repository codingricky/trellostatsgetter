class AddActionsToDownloadedCards < ActiveRecord::Migration[5.0]
  def change
    add_column :downloaded_cards, :action_data, :data
  end
end
