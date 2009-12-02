
namespace :db do ; namespace :import do 

  desc "Import Employee Information from import/employees.tsv into database"
  task (:employees => :environment) do
    STDOUT.sync = true

  end

end
