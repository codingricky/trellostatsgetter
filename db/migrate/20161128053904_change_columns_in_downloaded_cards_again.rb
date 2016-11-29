class ChangeColumnsInDownloadedCardsAgain < ActiveRecord::Migration[5.0]
  def change
    remove_column :downloaded_cards, :start_date, :time
    remove_column :downloaded_cards, :end_date, :time
    add_column :downloaded_cards, :start_date, :datetime
    add_column :downloaded_cards, :end_date, :datetime
  end
end