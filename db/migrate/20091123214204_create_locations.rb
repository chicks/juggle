class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
