class ChangeColumnsInDownloadedCards < ActiveRecord::Migration[5.0]
  def change
    remove_column :downloaded_cards, :start_date, :string
    remove_column :downloaded_cards, :end_date, :string
    add_column :downloaded_cards, :start_date, :time
    add_column :downloaded_cards, :end_date, :time
  end
end
