class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :name
      t.string :legal_name
      t.string :title
      t.string :status
      t.string :user_name
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

    # we need this employee object to occupy the top of the tree.
    Employee.connection.execute("insert into employees values (1,'Root','Root','Root','Internal','','','',1,'','','','')")
    
  end

  def self.down
    drop_table :employees
  end
end
