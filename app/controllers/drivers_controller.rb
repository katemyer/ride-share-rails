class DriversController < ApplicationController
  # https://stackoverflow.com/a/34252150
  skip_before_action :verify_authenticity_token
  def index
    @drivers = Driver.all #Driver is pulling data from the Drivers table in our database
  end

  def show
    driver_id = params[:id].to_i
    @driver = Driver.find_by_id(driver_id)
    #based on driver, can find all associated trips
    #@trips can now be accessed by the view
    @trips = @driver.trips
   if @driver.nil?
      #redirect_to :action => 'index'
      head :not_found
      return   
    end
  end

  # POST /driver
  # how to use it with postman https://medium.com/@oliver.seq/creating-a-rest-api-with-rails-2a07f548e5dc
  def create 
    #instantiate a new driver
    # @driver = Driver.new(name: params[:driver][:name], vin: params[:driver][:vin], available: params[:driver][:available])
    @driver = Driver.new(driver_params)
    if @driver.save # save returns true if the database insert succeeds
      #redirect_to root_path # go to the index so we can see the driver in the list
      redirect_to driver_path(@driver.id) #goes to page where drivers/:id page
      return
    else # save failed :(
      render :new # show the new task form view again
      return
    end
  end

  def new
    @driver = Driver.new
  end
  
  def edit
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      #head :not_found
      redirect_to root_path
      return
    end
  end

  def update
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      head :not_found
      return
    elsif @driver.update(
      name: params[:driver][:name], 
      vin: params[:driver][:vin],
      available: params[:driver][:available]
    )
      redirect_to driver_path # go to the index so we can see the book in the list
      return
    else # save failed :(
      render :edit # show the new driver form view again
      return
    end
  end

  def destroy
    driver_id = params[:id]
    @driver = Driver.find_by_id(driver_id)

    if @driver.nil?
      head :not_found
      return
    end

    @driver.destroy

    redirect_to drivers_path
    return
  end
end

private

def driver_params
  return params.require(:driver).permit(:name, :vin, :available)
end