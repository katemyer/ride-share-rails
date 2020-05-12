require "test_helper"

describe DriversController do
  
  describe "index" do
    it "responds with success when there are many drivers saved" do
      Driver.create(name: "Bob", vin: "abcd1234")
      
      get drivers_path
      
      must_respond_with :success
      
    end
    
    it "responds with success when there are no drivers saved" do
      Driver.destroy_all
      
      get drivers_path
      
      must_respond_with :success
    end
  end
  
  describe "show" do
    it "responds with success when showing an existing valid driver" do
      
      driver = Driver.create(name: "Susi", vin: "1234567891")
      
      get driver_path(driver.id)
      
      must_respond_with :success
    end
    
    it "responds with 404 with an invalid driver id" do
      
      get driver_path(-1)
      
      must_respond_with :not_found
      
    end
  end
  
  describe "new" do
    it "responds with success" do
      get new_driver_path
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new driver with valid information accurately, and redirect" do
      
      driver_hash = {
        driver: {
          name: "Mew",
          vin: "2345678910"
        }
      }
      
      expect {
        post drivers_path, params: driver_hash
      }.must_differ 'Driver.count', 1
      
      new_driver= Driver.find_by(name: driver_hash[:driver][:name])
      expect(new_driver.name).must_equal driver_hash[:driver][:name]
      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]
      
      must_redirect_to driver_path(new_driver.id)
      
    end
    
    it "does not create a driver if the form data violates Driver validations, and responds with a render" do
      
      driver_hash = {
        driver: {
          name: "Baron",
          vin: " "}
        }
        
        expect {
          post drivers_path, params: driver_hash
        }.must_differ "Driver.count", 0
        
        must_respond_with :success
      end
    end
    
    describe "edit" do
      it "responds with success when getting the edit page for an existing, valid driver" do
        
        new_driver = Driver.create(name: "Mau", vin: "4567891011")
        
        get edit_driver_path(new_driver)
        
        must_respond_with :success
        
      end
      
      it "responds with redirect when getting the edit page for a non-existing driver" do
        
        get edit_driver_path("987")
        must_redirect_to root_path
        
      end
    end
    
    describe "update" do
      it "can update an existing driver with valid information accurately, and redirect" do
        
        new_driver = Driver.create(name: "Brownie", vin: "0987654321")
        driver_hash = {
          driver: {
            name: "Bella",
            vin: "9876543210"
          }
        }
        patch driver_path(new_driver.id), params: driver_hash
        
        updated = Driver.find_by(id: new_driver.id)
        
        expect(updated.name).must_equal driver_hash[:driver][:name]
        expect(updated.vin).must_equal driver_hash[:driver][:vin]
        
        must_respond_with :redirect
        must_redirect_to driver_path(new_driver)
        
      end
      
      it "does not update any driver if given an invalid id, and responds with a 404" do
        patch driver_path(-1)
        
        must_respond_with :not_found
        
      end
      
      it "does not create a driver if the form data violates Driver validations, and responds with a render" do
        new_driver = Driver.create(name: "Petunia", vin: "765432198")
        
        driver_hash = {
          driver: {
            name: "",
            vin: "1234567891"
          }
        }
        
        expect {
          patch driver_path(new_driver.id), params: driver_hash
        }.must_differ "Driver.count", 0
        
        must_respond_with :success
        
      end
    end
    
    describe "destroy" do
      it "destroys the driver instance in db when driver exists, then redirects" do
        
        driver = Driver.create(name: "Bubbles", vin: "1234567891")
        
        expect {
          delete driver_path(id: driver.id)
        }.must_differ 'Driver.count', -1
        
        deleted = Driver.find_by(id: driver.id)
        expect(deleted).must_be_nil
        
        must_redirect_to drivers_path
      end
      
      it "does not change the db when the driver does not exist, then responds with " do
        expect {
          delete driver_path(id: -2)
        }.must_differ 'Driver.count', 0
        
      end
    end
  end