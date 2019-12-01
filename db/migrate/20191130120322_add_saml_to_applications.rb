class AddSamlToApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :applications, :is_saml, :boolean
    add_column :applications, :saml_service_provider, :text
    add_column :applications, :saml_entity_id, :text
    add_column :applications, :saml_certificate, :text
    add_column :applications, :saml_private_key, :text
    add_column :applications, :saml_algorithm, :text
  end
end
