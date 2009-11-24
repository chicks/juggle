class CreateEmailAddresses < ActiveRecord::Migration
  def self.up
    create_table :email_addresses do |t|
      t.string  :address
      t.boolean :is_primary
      t.integer :employee_id
      t.timestamps
    end
    
    add_index :email_addresses, :employee_id
    
  end

  def self.down
    drop_table :email_addresses
  end
end
