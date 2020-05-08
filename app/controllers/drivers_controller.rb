class DriversController < ApplicationController
  def index
    @drivers = Driver.all #Driver is pulling data from the Drivers table in our database
  end
end
