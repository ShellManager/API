class AddSamlToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :saml_enabled, :boolean
    add_column :users, :saml_email, :text
    User.update_all(saml_enabled: false)
  end
end
