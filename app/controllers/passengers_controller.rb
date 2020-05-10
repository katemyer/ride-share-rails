class PassengersController < ApplicationController
  
  def index
    @passengers = Passenger.all
  end

  def show
    passenger_id = params[:id]
    @passenger = Passenger.find_by(id: passenger_id)

    if @passenger.nil?
      head :not_found
      return
    end
  end

  def new
    @passenger = Passenger.new
end

  def edit
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      head :not_found
      return
    end
  end

  def create 
    @passenger = Passenger.new(name: params[:passenger][:name], phone_num: params[:passenger][:phone_num])
    if @passenger.save
      redirect_to passenger_path(@passenger.id)
      return
    else
      render :new
      return
    end
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])
    if @passenger.nil?
      head :not_found
      return
    elsif @passenger.update(
      name: params[:passenger][:name],
      phone_num: params[:passenger][:phone_num]
    )

    redirect_to passenger_path
    return
  else
    render :edit
    return
  end
end
  
  def destroy
    passenger_id = params[:id]
    @passenger = Passenger.find_by_id(passenger_id)

    if @passenger.nil?
      head :not_found
      return
    end

    @passenger.destroy

    redirect_to passengers_path
    return
  end

end