class CreateLocationAliases < ActiveRecord::Migration
  def self.up
    create_table :location_aliases do |t|
      t.string  :name
      t.integer :location_id

      t.timestamps
    end

    add_index(:location_aliases, :name)
  end

  def self.down
    drop_table :location_aliases
  end
end
