require 'tsv2class'
require 'pp'

namespace :db do ; namespace :import do 
  

  # 
  # This is a big recursive method.  
  #
  # It will keep calling itself until it resolves all missing employees.
  # Recursion is neccessary because you need to add an employee's 
  # manager before you add the employee, and I didn't want to 
  # enforce order in the import file.  If an employee reports to himself,
  # then the manager object is not created.        
  #   
  def create_employee(employee, employees)
   
    index = (employees.index(employee) + 1).to_s 
    puts "#{index}: Employee  : Processing: #{employee.name}"
    e           = Employee.find_or_create_by_name(employee.name)

    puts "#{index}: Manager   : Looking up: #{employee.reports_to}"
    manager     = Employee.find_by_name(employee.reports_to)

    puts "#{index}: Department: Looking up: #{employee.department}"
    department  = Department.find_by_name(employee.department.split(' - ')[0])

    puts "#{index}: Location  : Looking up: #{employee.location}"
    location    = Location.find_or_create_by_address(employee.location)

    # If we don't have an employee record for the manager, we need to create one. 
    if manager.class != Employee 
      # Grabs the manager from the list of employees
      m = employees.select {|emp| emp.name == employee.reports_to}[0]
      # Create manager employee record, unless the employee reports to himself
      puts "#{index}: Manager   : Creating: #{employee.reports_to}"
      manager = create_employee(m, employees) 
    end
    
    # Create any missing departments
    if department == nil
      puts "#{index}: Department: Creating: #{employee.department}"
      department = Department.new
      department.name, department.number = employee.department.split(' - ')
      department.save     
    end
    
    e.legal_name = employee.first_name + " " + employee.last_name
    e.title      = employee.title
    e.status     = "Active"
    e.manager    = manager 
    e.department = department
    e.location   = location
    e.start_of_employment = DateTime.new
    e.end_of_employment   = ""
    e.save
    return e 

  end

  desc "Import Employee Information from import/employees.tsv into database"
  task(:employees => :environment) do
    STDOUT.sync = true
    employees = Tsv2Class.new("import/employees.tsv")
    employees.each do |e|
      create_employee(e, employees)
    end
  end

end;end
