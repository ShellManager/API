class AddRelaystateToSamltokens < ActiveRecord::Migration[6.0]
  def change
    add_column :saml_tokens, :relaystate, :text
  end
end
