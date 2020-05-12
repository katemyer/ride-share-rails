require "test_helper"

describe TripsController do
  let (:passenger) {
    Passenger.create(name: "Petunia", phone_num: "555-555-5555")
  }
  let (:driver) {
    Driver.create(name: "Susi", vin: "1234567891")
  }
  let (:trip) {
    Trip.create(date: Date.today, rating: 2, cost: 30, driver_id: driver.id, passenger_id: passenger.id)
  }
  describe "show" do
    it "responds with success when showing an existing trip" do
      get trip_path(trip)
      must_respond_with :success
    end
    
    it "responds with 404 with an invalid trip id" do
      get trip_path(-1)
      must_respond_with :not_found
    end
  end
  
  describe "create" do
    it "can create a new trip with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data
      trip_hash = {
        trip: {
          date: Date.today,
          rating: 5,
          cost: 20,
          passenger_id: passenger.id,
          driver_id: driver.id,
        }
      }
      
      expect {
        post trips_path, params: trip_hash
      }.must_differ 'Trip.count', 1
      
      new_trip = Trip.find_by(passenger_id: trip_hash[:trip][:passenger_id])
      
      must_redirect_to trip_path(new_trip.id)
    end
    
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid trip" do
      get edit_trip_path(trip)
      must_respond_with :success
      
    end
    
    it "responds with redirect when getting the edit page for a non-existing trip" do
      get edit_trip_path(-1)
      must_redirect_to trip_path
    end
  end
  
  describe "update" do
    it "can update an existing trip with valid information accurately, and redirect" do
      original_trip = Trip.create(date: Date.today, rating: 2, cost: 30, driver_id: driver.id, passenger_id: passenger.id)
      
      trip_hash = {
        trip: {
          rating: 3
        }
      }
      
      patch trip_path(original_trip.id), params: trip_hash
      
      expect(Trip.find_by(id: original_trip.id).rating).must_equal 3
      
      must_respond_with :redirect
      must_redirect_to trip_path(original_trip)
    end
    
    it "does not update trips if given an invalid id, and responds with a 404" do
      patch trip_path(-1)
      must_respond_with :not_found
      
    end
  end
  
  describe "destroy" do
    it "destroys the trip instance in db when trip exists, then redirects" do
      new_trip = Trip.create(date: Date.today, rating: 2, cost: 30, driver_id: driver.id, passenger_id: passenger.id)
      
      expect {
        delete trip_path(id: new_trip.id)
      }.must_differ 'Trip.count', -1
      
      deleted = Trip.find_by(id: new_trip.id)
      expect(deleted).must_be_nil
      
      must_redirect_to trips_path
    end
    it "does not change the db when the driver does not exist, then responds with " do
      expect {
        delete trip_path(id: -1)
      }.must_differ 'Trip.count', 0
    end
  end
end