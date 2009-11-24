class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers do |t|
      t.string  :number
      t.string  :type
      t.boolean :is_primary
      t.integer :employee_id
      t.timestamps
    end
    
    add_index :phone_numbers, :employee_id
  end

  def self.down
    drop_table :phone_numbers
  end
end
