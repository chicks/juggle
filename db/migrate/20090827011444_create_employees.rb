class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :name
      t.string :legal_name
      t.string :title
      t.string :status
      t.date :start_of_employment
      t.date :end_of_employment   

      t.integer :manager_id
      t.integer :department_id
      t.integer :location_id

      t.timestamps
    end
    
    add_index :employees, :manager_id
    add_index :employees, :department_id
    add_index :employees, :location_id
    
  end

  def self.down
    drop_table :employees
  end
end
