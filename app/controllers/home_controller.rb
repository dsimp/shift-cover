# app/controllers/home_controller.rb

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    case params[:filter]
    when 'eligible'
      @available_jobs = current_user.eligible_jobs
    when 'ineligible'
      @available_jobs = current_user.ineligible_jobs
    else
      @available_jobs = current_user.eligible_jobs + current_user.ineligible_jobs
    end

    @posted_jobs = current_user.posted_jobs
  end
end
