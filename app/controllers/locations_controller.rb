class LocationsController < ApplicationController
  before_action :logged_in

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      flash[:success] = "#{@location.name} added to the tracker!"
      redirect_to @location
    else
      render "locations/new"
    end
  end

  def index
    @locations = Location.order(name: :asc)
  end

  def show
    @location = Location.find(params[:id])
    @items = Item.where(location_id: @location.id)
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(location_params)
      flash[:success] = "#{@location.name} updated!"
      redirect_to @location
    else
      render "locations/edit"
    end
  end

  def destroy
    @location = Location.find(params[:id]).destroy
    flash[:success] = "#{@location.name} and all associated items deleted"
    redirect_to locations_path
  end

  private

  def location_params
    params.require(:location).permit(:name)
  end

end
