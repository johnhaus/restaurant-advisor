class ReviewsController < ApplicationController
  before_action :set_restaurant

  def new
    @review = Review.new
    authorize @restaurant
    authorize @review
  end
  def create
    @review = Review.new(review_params)
    @review.user = current_user
    @review.restaurant = @restaurant
    authorize @restaurant
    authorize @review

    if @review.save
      redirect_to restaurant_path(@restaurant)
    else
      render :new
    end
  end

  private
  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    authorize @restaurant
  end
  def review_params
    params.require(:review).permit(:content, :restaurant_id, :review_id)
  end
end
