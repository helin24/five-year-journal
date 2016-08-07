class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :user_id
      t.date :display_date
      t.text :text
      t.boolean :is_public

      t.timestamps null: false
    end

    add_index :entries, [:user_id, :display_date], unique: true
  end
end
