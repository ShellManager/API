class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.date   :date_of_birth
      t.integer :permission_level
      t.string :password_digest
      t.string :password_hash
      t.string :encryption_key
      t.inet :last_login_ip
      t.string :fingerprints
      t.string :tfa_key
      t.uuid :user_global_id
      t.string :api_key
      t.string :activation_token
      t.boolean :activated
      t.boolean :active
      t.boolean :protected
      t.timestamps
    end
  end
end
