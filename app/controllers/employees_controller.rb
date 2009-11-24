class EmployeesController < ApplicationController
  
  def index
    @employees = Employee.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @employees }
      format.js
    end
  end
  
end
