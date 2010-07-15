class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :display_name
      t.string :title
      t.string :user_type
      t.string :time_zone

      t.timestamps
    end

    create_table :roles do |t|
      t.string :name
      t.text :desc
    end

    create_table :teams do |t|
      t.string :name
      t.text :desc
    end 

    #add_index "roles", ["name"], :name => "index_roles_on_name"
    #add_index "teams", ["name"], :name => "index_teams_on_name"
   
    create_table(:users_roles, {:id => false}) do |t|
      t.integer :user_id
      t.integer :role_id
    end

    create_table :users_teams, {:id => false} do |t|
      t.integer :user_id
      t.integer :team_id

      t.timestamps
    end

    add_index :users_roles, :user_id
    add_index :users_roles, :role_id
  end

  def self.down
    drop_table :users
  end
end
