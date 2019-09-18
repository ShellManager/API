class CreateLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :logs do |t|
      t.uuid :user
      t.boolean :administrative
      t.text :action
      t.timestamps
    end
  end
end
