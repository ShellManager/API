class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :site_name
      t.string :site_protocol
      t.string :recaptcha_site_key
      t.string :recaptcha_secret_key

      t.timestamps
    end
  end
end
