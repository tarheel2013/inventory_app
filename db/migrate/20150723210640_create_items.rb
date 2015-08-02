class CreateItems < ActiveRecord::Migration

  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :image
      t.integer :location
      t.timestamps null: false
    end
  end

end
