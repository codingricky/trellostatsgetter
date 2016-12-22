class CreateSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.string :name
      t.text :keywords

      t.timestamps
    end
  end
end
