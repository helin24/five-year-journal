class CreateGoogleAuthentications < ActiveRecord::Migration
  def change
    create_table :google_authentications do |t|
      t.string :email
      t.string :name
      t.string :profile_url

      t.timestamps null: false
    end

    add_index :google_authentications, :email, :unique => true
  end
end
