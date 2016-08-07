class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.references :login, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
