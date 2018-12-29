class ReviewsController < ApplicationController
  before_action :set_restaurant

  def new
    @review = Review.new
    authorize @restaurant
  end
  def create
    @review = Review.new(review_params)
    @user = current_user
    authorize @review
    raise
    if @review.save
    redirect_to restaurant_path(@restaurant)
    else
      render :new
    end
  end

  private
  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
  def review_params
    params.require(:review).permit(:content, :restaurant_id)

  end

end
