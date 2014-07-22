class ReviewsController < ApplicationController
  before_filter :require_user

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(permitted_params)
    if review.save
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  def permitted_params
    params.require(:review).permit(:content, :rating).merge!(user: current_user)
  end
end