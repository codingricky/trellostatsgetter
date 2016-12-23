class ChangeCardDataTypeToJson < ActiveRecord::Migration[5.0]
  def change
    remove_column :downloaded_cards, :actions
    add_column :downloaded_cards, :actions, :json
  end
end
