class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :position, {only_integer: true}

  # Second Delegate
  # def video_title
  #   video.title
  # end

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    review = Review.where(user_id: user.id, video_id: video.id).first
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end

  end

  def category_name
    #delegate
    #video.category.name
    category.name
  end

  # delegate
  # def category
  #   video.category
  # end


  private

  def review
    @review ||= Review.where(user_id:  user_id, video_id: video_id).first
  end
end