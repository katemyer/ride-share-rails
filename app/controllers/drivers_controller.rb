class DriversController < ApplicationController
  # https://stackoverflow.com/a/34252150
  skip_before_action :verify_authenticity_token
  def index
    @drivers = Driver.all #Driver is pulling data from the Drivers table in our database
  end

  def show
    driver_id = params[:id].to_i
    @driver = Driver.find_by_id(driver_id)
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
    @driver = Driver.new(name: params[:driver][:name], vin: params[:driver][:vin], available: params[:driver][:available])
    if @driver.save # save returns true if the database insert succeeds
      #redirect_to root_path # go to the index so we can see the task in the list
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
  
  # def edit
  #   @task = Task.find_by(id: params[:id])

  #   if @task.nil?
  #     #head :not_found
  #     redirect_to root_path
  #     return
  #   end
  # end

  # def update
  #   @task = Task.find_by(id: params[:id])
  #   if @task.nil?
  #     head :not_found
  #     return
  #   elsif @task.update(
  #     name: params[:task][:name], 
  #     description: params[:task][:description],
  #     completed_at: params[:task][:completed_at]
  #   )
  #     redirect_to task_path # go to the index so we can see the book in the list
  #     return
  #   else # save failed :(
  #     render :edit # show the new book form view again
  #     return
  #   end
  # end

  # def destroy
  #   task_id = params[:id]
  #   @task = Task.find_by_id(task_id)

  #   if @task.nil?
  #     head :not_found
  #     return
  #   end

  #   @task.destroy

  #   redirect_to tasks_path
  #   return
  # end
end
