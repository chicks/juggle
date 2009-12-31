class CreateLocationAliases < ActiveRecord::Migration
  def self.up
    create_table :location_aliases do |t|
      t.string  :name
      t.integer :location_id

      t.timestamps
    end

    add_index(:location_aliases, :name)
    add_index(:location_aliases, :location_id)
  end

  def self.down
    drop_table :location_aliases
  end
end
