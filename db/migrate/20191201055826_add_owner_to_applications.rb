class AddOwnerToApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :applications, :owner, :uuid
  end
end
