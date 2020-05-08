class PassengersController < ApplicationController
  
  def index
    @passengers = Passenger.all #Task is pulling data from the Tasks table in our database
  end

  def show

  end

end
