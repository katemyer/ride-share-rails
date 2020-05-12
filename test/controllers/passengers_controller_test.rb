require "test_helper"

describe PassengersController do
  let (:passenger) {
    Passenger.create(name: "Petunia", phone_num: "555-555-5555")
  }
  describe "index" do
    it "responds with success when there's a passenger saved" do
      get passengers_path
      must_respond_with :success
    end
  end
  
  describe "show" do
    # Your tests go here
    it "responds with success when showing an existing valid passenger" do
      get passenger_path(passenger.id)
      
      must_respond_with :success
    end
    
    it "responds with 404 with an invalid passenger id" do
      get passenger_path(-1)
      
      must_respond_with :not_found
    end
    
  end
  
  describe "new" do
    it "responds with success" do
      get new_passenger_path
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new passenger with valid information accurately, and redirect" do
      passenger_hash = {
        passenger: {
          name: "Benji",
          phone_num: "123-456-7891"
        }
      }
      
      expect {
        post passengers_path, params: passenger_hash
      }.must_change "Passenger.count", 1
      
      new_passenger = Passenger.find_by(name: passenger_hash[:passenger][:name])
      expect(new_passenger.name).must_equal passenger_hash[:passenger][:name]
      expect(new_passenger.phone_num).must_equal passenger_hash[:passenger][:phone_num]
      
      must_redirect_to passenger_path(new_passenger.id)
    end
    
    it "does not create a passenger if the form data violates Passenger validations, and responds with a redirect" do
      passenger_hash = {
        passenger: {
          name: "Smokey",
          phone_num: " "}
        }
        # Act-Assert
        # Ensure that there is no change in Passenger.count
        expect {
          post passengers_path, params: passenger_hash
        }.must_differ "Passenger.count", 0
        
        # Assert
        # Check that the controller renders
        #must_redirect_to passengers_path
        must_respond_with :success
      end
    end
    
    describe "edit" do
      it "responds with success when getting the edit page for an existing, valid passenger" do
        new_passenger = Passenger.create(name: "Mau", phone_num: "999-888-7777")
        
        
        # Act
        get edit_passenger_path(new_passenger)
        
        # Assert
        must_respond_with :success
      end
      
      it "responds with redirect when getting the edit page for a non-existing passenger" do
        get edit_passenger_path(-1)
        must_redirect_to root_path
      end
    end
    
    describe "update" do
      it "can update an existing driver with valid information accurately, and redirect" do
        new_passenger = Passenger.create(name: "Brownie", phone_num: "206-555-5555")
        passenger_hash = {
          passenger: {
            name: "Bella",
            phone_num: "203-555-5555"
          }
        }
        patch passenger_path(new_passenger.id), params: passenger_hash
        
        updated = Passenger.find_by(id: new_passenger.id)
        
        expect(updated.name).must_equal passenger_hash[:passenger][:name]
        expect(updated.phone_num).must_equal passenger_hash[:passenger][:phone_num]
        
        must_respond_with :redirect
        must_redirect_to passenger_path(new_passenger)
      end
      
      it "does not update passenger if given an invalid id, and responds with a 404" do
        patch passenger_path(-1)
        must_respond_with :not_found
      end
      
      it "does not create a passenger if the form data violates Passenger validations, and responds with a redirect" do
        # Note: This will not pass until ActiveRecord Validations lesson
        # Arrange
        # Ensure there is an existing driver saved
        # Assign the existing driver's id to a local variable
        # Set up the form data so that it violates Driver validations
        new_passenger = Passenger.create(name: "Yara", phone_num: "787-555-5555")
        
        passenger_hash = {
          passenger: {
            name: "",
            phone_num: "787-555-5555"
          }
        }
        # Act-Assert
        # Ensure that there is no change in Driver.count
        expect {
          patch passenger_path(new_passenger.id), params: passenger_hash
        }.must_differ "Passenger.count", 0
        
        # Assert
        # Check that the controller redirects
        must_respond_with :success
        
      end
    end
    
    describe "destroy" do
      it "destroys the driver instance in db when passenger exists, then redirects" do
        passenger = Passenger.create(name: "Bubbles", phone_num: "334-123-4567")
        
        expect {
          delete passenger_path(id: passenger.id)
        }.must_differ 'Passenger.count', -1
        
        deleted = Passenger.find_by(id: passenger.id)
        expect(deleted).must_be_nil
        
        must_redirect_to passengers_path
      end
      it "does not change the db when the passenger does not exist, then responds with " do
        expect {
          delete passenger_path(id: -2)
        }.must_differ 'Passenger.count', 0
        
      end
    end
  end