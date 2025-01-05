class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :nanoid
      t.string :original_session_nanoid
      t.json :data, default: {}

      t.integer "status"
      t.string "name"
      t.string "avatar"
      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
