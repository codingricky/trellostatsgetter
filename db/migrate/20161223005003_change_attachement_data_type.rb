class ChangeAttachementDataType < ActiveRecord::Migration[5.0]
  def change
    remove_column :downloaded_cards, :attachments
    add_column :downloaded_cards, :attachments, :json
  end
end
