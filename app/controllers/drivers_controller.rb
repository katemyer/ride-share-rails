class DriversController < ApplicationController
  def index
    @drivers = Driver.all #Task is pulling data from the Tasks table in our database
  end
end
