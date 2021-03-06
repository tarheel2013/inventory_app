class ItemsController < ApplicationController
  before_action :logged_in

  def index
    @location = Location.find(params[:location_id])
    @items = Item.order(name: :asc)
  end

  def show
    @location = Location.find(params[:location_id])
    @item = Item.find(params[:id])
    @last_in = Status.where("item_id == ?", params[:id]).where("name == ?", "In").last
    @future_statuses = Status.where("item_id == ?", params[:id]).where("name != ?", "In").where("created_at >= ?", @last_in.created_at)
    @past_statuses = Status.where("item_id == ?", params[:id]).where("name != ?", "In").where("due_date <= ?", @last_in)
    if @status = Status.where("item_id == ?", @item.id).where("start_time <= ?", Date.today).where("due >= ?", Date.today).where("created_at >= ?", @last_in.created_at).last
    else @status = Status.where("item_id == ?", @item.id).where("start_time <= ?", Date.today).where("created_at >= ?", @last_in.created_at).last
    end
  end

  def new
    @location = Location.find(params[:location_id])
    @item = Item.new
    @status = Status.new
  end

  def create
    @location = Location.find(params[:location_id])
    @item = Item.new(item_params)
    if @item.save
      @status = Status.new(item_id: @item.id, name: "In", holder: nil, due: nil).save
      flash[:success] = "#{@item.name} added to the tracker!"
      redirect_to location_path(@item.location_id)
    else
      render "items/new"
    end
  end

  def edit
    @location = Location.find(params[:location_id])
    @item = Item.find(params[:id])
    @status = Status.where(item_id: @item.id).last
  end

  def update
    @location = Location.find(params[:location_id])
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      flash[:success] = "#{@item.name} updated!"
      redirect_to location_item_path(@location.id, @item.id)
    else
      render "items/edit"
    end
  end

  def destroy
    Item.find(params[:id]).destroy
    flash[:success] = "Item deleted"
    redirect_to location_path(params[:location_id])
  end

  def import
    @location = Location.find(params[:location_id])
    Item.import(params[:file])
      flash[:success] = "Items imported!"
      redirect_to location_path(@location.id)
  # else
  #    flash[:danger] = "Something went wrong. Check your file and try again."
  #    redirect_to location_path(@location.id)
  #  end
  end

  private

    def item_params
      params.require(:item).permit(:name, :description, :image, :location_id)
    end

end
