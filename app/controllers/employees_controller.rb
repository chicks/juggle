class EmployeesController < ApplicationController
  
  def index
    @employees = Employee.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @employees }
      format.js
    end
  end
  
  def new
    @employee = Employee.new
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def json
    @employees = Employee.root
    render :json => @employees.to_json(:include => { :subordinates => { :include => :subordinates }})
  end
  
end
