class EmployeesController < ApplicationController
  
  def index
    @employees = Employee.find(:all, :conditions => {:status => "Active"})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @employees }
      format.js
    end
  end

  def organization
    @employees = Employee.find(:all, :conditions => {:status => "Active"})
    respond_to do |format|
      format.html # organiszation.html.erb
      format.xml  { render :xml => @employees }
      format.js
    end

  end
  
end
