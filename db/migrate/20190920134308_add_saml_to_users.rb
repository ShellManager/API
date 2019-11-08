class AddSamlToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :saml_enabled, :boolean
    User.update_all(saml_enabled: false)
  end
end
