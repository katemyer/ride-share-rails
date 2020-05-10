class TripsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @trips = Trip.all
  end

  def show
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)

    if @trip.nil?
      return
    end
  end

  def new
    @date = Date.today,
    @cost = rand(1..50),
    @driver = Driver.available_driver.id
    @trip = Trip.new
    passenger_id = params[:passenger_id]
    if passenger_id.nil?
      @passengers = Passenger.all
    else
      @passengers = [Passenger.find_by(id: passenger_id)]
    end
  end

  def create
    if params[:passenger_id]
      @passenger = Passenger.find_by(id: params[:passenger_id])
      @trip = @passenger.trips.new
    else
      trip_request = @passenger.trip_request
      @trip = Trip.create(trip_request)
      @trip.passenger = @passenger
      @trip.save
      return
    render :new
    return
  end
  end

def edit
  @trip = Trip.find_by(id: params[:id])

  if @trip.nil?
    head :not_found
    return
  end
end

def update
  @trip = Trip.find_by(id: params[:id])
  if @trip.nil?
    head :not_found
    return
  elsif @trip.update(trip_params)
  redirect_to trip_path
end
end

def destroy
  @trip = Trip.find_by(id: params[:id])

  if @trip.nil?
    return
  end
  @trip.destroy
  redirect_to trip_path
  return
end
  
end