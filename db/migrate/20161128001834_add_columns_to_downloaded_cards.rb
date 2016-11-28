class AddColumnsToDownloadedCards < ActiveRecord::Migration[5.0]
  def change
    remove_column :downloaded_cards, :name, :string
    add_column :downloaded_cards, :sanitized_name, :string
    add_column :downloaded_cards, :card_id, :string
    add_column :downloaded_cards, :list_id, :string
    add_column :downloaded_cards, :list_name, :string
    add_column :downloaded_cards, :start_date, :string
    add_column :downloaded_cards, :end_date, :string
    add_column :downloaded_cards, :url, :string
  end
end
