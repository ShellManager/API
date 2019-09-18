class CreateApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.text :name
      t.text :redirect_uri
      t.text :application_id
      t.timestamps
    end
  end
end
