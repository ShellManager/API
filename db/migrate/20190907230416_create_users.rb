class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :password_hash
      t.string :encryption_key
      t.inet :last_login_ip
      t.hash :fingerprints
      t.string :tfa_key
      t.uuid :user_global_id
      t.string :api_key
      t.string :activation_token
      t.boolean :activated
      t.boolean :active
      t.boolean :shell_active
      t.string :shell_username

      t.timestamps
    end
  end
end
