class User < ActiveRecord::Base
  has_and_belongs_to_many :roles, :join_table => "users_roles"
  has_and_belongs_to_many :teams, :join_table => "users_teams"
end
