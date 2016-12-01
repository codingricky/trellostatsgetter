class AddMoreColumnsToDownloadedCards < ActiveRecord::Migration[5.0]
  def change
    add_column :downloaded_cards, :attachments, :string
    add_column :downloaded_cards, :source, :string
  end
end
