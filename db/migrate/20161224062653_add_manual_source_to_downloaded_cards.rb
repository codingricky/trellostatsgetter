class AddManualSourceToDownloadedCards < ActiveRecord::Migration[5.0]
  def change
    add_column :downloaded_cards, :manual_source, :string
  end
end
