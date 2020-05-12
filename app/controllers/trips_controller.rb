class TripsController < ApplicationController
  #Pages Requiremnt
  LIST_PER_PAGE = 10
  
  skip_before_action :verify_authenticity_token
  
  def index
    @page = params.fetch(:page, 0).to_i
    @trips = Trip.all.order(id: :asc).offset(@page * LIST_PER_PAGE).limit(LIST_PER_PAGE)
    @last_page = Trip.all.count / LIST_PER_PAGE
  end
  
  def show
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)
    
    if @trip.nil?
      head :not_found
      return
    end
  end
  
  def new
    @date = Date.today
    @cost = rand(1..50)
    #getting first available driver from db
    @driver = Driver.where(available: true).first 
    @trip = Trip.new
    @passenger_id = params.fetch(:passenger_id, "").to_i
  end
  
  def create 
    #creating a trip, save to database
    @trip = Trip.new(trip_params)
    if @trip.save
      #update status of driver
      driver_id = @trip.driver_id
      #trip has relationship with driver in trip.rb model
      #can access driver status to set to false
      @trip.driver.available = false
      # save driver status to database
      @trip.driver.save
      #****************************
      #Another way to change status without using relations
      # #driver object
      # a_driver = Driver.find_by(id: driver_id)
      # a_driver.available = false #set status to false
      # a_driver.save #must save driver in DB
      #****************************
      redirect_to trip_path(@trip.id) 
      return
    else 
      render :new 
      return
    end
  end
  
  def edit
    @trip = Trip.find_by(id: params[:id])
    
    if @trip.nil?
      redirect_to trip_path
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
    redirect_to trips_path
    return
  end 
  
end

private

def trip_params
  return params.require(:trip).permit(:driver_id, :passenger_id, :date, :rating, :cost)
end