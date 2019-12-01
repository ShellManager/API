class RemoveSamlEnabledFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :saml_enabled
  end
end
