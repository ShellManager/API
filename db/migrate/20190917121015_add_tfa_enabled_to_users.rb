class AddTfaEnabledToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tfa_enabled, :boolean
    User.update_all(tfa_enabled: false)
  end
end
