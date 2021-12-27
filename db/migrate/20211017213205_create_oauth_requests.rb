class CreateOauthRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_requests do |t|
      t.string :client_id
      t.string :redirect_uri
      t.string :scope
      t.string :response_mode
      t.string :state
      t.string :nonce
      t.uuid   :caller_id

      t.timestamps
    end
  end
end
