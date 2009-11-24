class CreateImHandles < ActiveRecord::Migration
  def self.up
    create_table :im_handles do |t|
      t.string :name
      t.string :provider
      t.boolean :is_primary
      t.integer :employee_id
      t.timestamps
    end
    
    add_index :im_handles, :employee_id
    
  end

  def self.down
    drop_table :im_handles
  end
end
