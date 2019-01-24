class RestaurantsController < ApplicationController

  before_action :set_restaurant, only: [:show, :edit, :update, :destroy, :chef]
  skip_before_action :authenticate_user!, only: [:index, :show, :top]

  def chef
  end

  def top
    @top_restaurants = policy_scope(Restaurant.where(rating: 5))
  end

  def index
    @restaurants = policy_scope(Restaurant)
    @restaurants = Restaurant.where.not(latitude: nil, longitude: nil)

    @markers = @restaurants.map do |restaurant|
      {
        lng: restaurant.longitude,
        lat: restaurant.latitude
      }
    end
  end

  def show
    @restaurants = policy_scope(Restaurant)
  end

  def new
    @restaurant = Restaurant.new
    authorize @restaurant
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    authorize @restaurant

    if @restaurant.save
      redirect_to restaurants_path, notice: 'Restaurant was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to @restaurant, notice: 'Restaurant was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.'
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :city, :food_type, :rating, :photo, :chef, :photo_of_the_chef, :photo_cache, :photo_of_the_chef_cache)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end
end
