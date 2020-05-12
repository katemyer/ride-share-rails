require "test_helper"

describe DriversController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.

  describe "index" do
    it "responds with success when there are many drivers saved" do
      # Arrange
      # Ensure that there is at least one Driver saved
      Driver.create(name: "Bob", vin: "abcd1234")

      # Act
      get drivers_path
      # Assert
      must_respond_with :success

    end

    it "responds with success when there are no drivers saved" do
      # Arrange
      # Ensure that there are zero drivers saved
      Driver.destroy_all

      # Act
      get drivers_path

      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid driver" do
      # Arrange
      driver = Driver.create(name: "Susi", vin: "1234567891")
      # Ensure that there is a driver saved

      # Act
      get driver_path(driver.id)

      # Assert
      must_respond_with :success
    end

    it "responds with 404 with an invalid driver id" do
      # Arrange
      # Ensure that there is an id that points to no driver

      # Act
      get driver_path(-1)

      # Assert
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
      # Arrange
      # Set up the form data
      driver_hash = {
        driver: {
          name: "Mew",
          vin: "2345678910"
        }
      }

      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
      expect {
        post drivers_path, params: driver_hash
      }.must_differ 'Driver.count', 1

      new_driver= Driver.find_by(name: driver_hash[:driver][:name])
      expect(new_driver.name).must_equal driver_hash[:driver][:name]
      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]

      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      # Check that the controller redirected the user
      must_redirect_to driver_path(new_driver.id)

    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Driver validations
        driver_hash = {
          driver: {
            name: "Baron",
            vin: " "}
        }
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        post drivers_path, params: driver_hash
      }.must_differ "Driver.count", 0

      # Assert
      # Check that the controller redirects
      must_redirect_to drivers_path
    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      # Arrange
      # Ensure there is an existing driver saved
      new_driver = Driver.create(name: "Mau", vin: "4567891011")


      # Act
      get edit_driver_path(new_driver)

      # Assert
      must_respond_with :success

    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      get edit_driver_path("987")
      must_redirect_to root_path


      # Act

      # Assert

    end
  end

  describe "update" do
    it "can update an existing driver with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data
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

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data so that it violates Driver validations
      new_driver = Driver.create(name: "Petunia", vin: "765432198")

      driver_hash = {
        driver: {
          name: "",
          vin: "1234567891"
        }
      }
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(new_driver.id), params: driver_hash
      }.must_differ "Driver.count", 0

      # Assert
      # Check that the controller redirects
      must_redirect_to drivers_path

    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do
      # Arrange
      # Ensure there is an existing driver saved
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
