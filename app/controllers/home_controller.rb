
class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    case params[:filter]
    when 'eligible'
      @available_jobs = current_user.eligible_jobs.page(params[:page]).per(10)
    when 'ineligible'
      @available_jobs = current_user.ineligible_jobs.page(params[:page]).per(10)
    else
     
      all_jobs = current_user.eligible_jobs + current_user.ineligible_jobs
      @available_jobs = Kaminari.paginate_array(all_jobs).page(params[:page]).per(10)
    end
  
    @posted_jobs = current_user.posted_jobs.page(params[:page]).per(10)
  end
end
