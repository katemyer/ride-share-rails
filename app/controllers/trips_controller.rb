class TripsController < ApplicationController
  def index
    @trips = Trip.all #Trip is pulling data from the Trips table in our database
  end
end
