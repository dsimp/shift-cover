class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job

  def create
    unless @job.completed?
      redirect_to @job, alert: "You can only review a completed job."
      return
    end

    @review = @job.reviews.build(review_params)
    @review.reviewer = current_user
    
    # Determine the reviewee based on who is leaving the review
    if current_user == @job.opener
      @review.reviewee = @job.cover
    elsif current_user == @job.cover
      @review.reviewee = @job.opener
    else
      redirect_to @job, alert: "You are not authorized to leave a review for this job."
      return
    end

    if @review.save
      redirect_to @job, notice: 'Review successfully submitted.'
    else
      redirect_to @job, alert: "Review could not be saved: #{@review.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
