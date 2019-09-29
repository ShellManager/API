class CreateSamlTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :saml_tokens do |t|
      t.text :xml
      t.uuid :uuid
      t.timestamps
    end
  end
end
