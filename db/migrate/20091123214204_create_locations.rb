class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :coordinates
      
      t.timestamps
    end

    l = Location.new
    l.name = "Unknown"
    l.street_address = "Unknown"
    l.city = "Unknown"
    l.state = "Unknown"
    l.postal_code = "Unknown"
    l.country = "Unknown"
    l.coordinates = "0,0,0"
    l.save!
  end

  def self.down
    drop_table :locations
  end
end
