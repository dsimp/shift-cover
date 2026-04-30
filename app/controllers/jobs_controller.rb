class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: [:show, :edit, :update, :destroy, :cover, :complete]
  before_action :authorize_opener!, only: [:edit, :update, :destroy, :complete]
  before_action :authorize_business!, only: [:new, :create, :edit, :update, :destroy]
  before_action :authorize_employee!, only: [:cover]

  def index
    #Could've used ransack
    @jobs = if params[:filter] == 'eligible'
      current_user.eligible_jobs.page(params[:page]).per(10)
    elsif params[:filter] == 'ineligible'
      current_user.ineligible_jobs.page(params[:page]).per(10)
    else
      Job.where(cover_id: nil).page(params[:page]).per(10)
    end
  end

  def new
    @job = current_user.posted_jobs.new
  end

  def create
    @job = current_user.posted_jobs.new(job_params)

    if @job.save
       NotifyUsersOfNewJob.new(@job).call
      redirect_to @job, notice: "Job was successfully created, and users have been notified."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @job is set by set_job
  end

  def edit
    # @job is set by set_job
  end

  def update
    if @job.update(job_params)
      redirect_to @job, notice: 'Job was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job.destroy
    redirect_to jobs_url, notice: 'Job was successfully deleted.'
  end

  def cover
    if current_user.has_profession?(@job.job_type)
      if @job.cover.present? || @job.covered?
        redirect_to @job, alert: 'Job has already been covered.'
      else
        @job.update(cover: current_user, status: :covered)
        redirect_to @job, notice: 'You have successfully covered this job.'
      end
    else
      redirect_to training_module_job_type_path(@job.job_type), alert: 'You need to complete the training module to cover this job.'
    end
  end

  def complete
    if @job.covered?
      @job.update!(status: :completed)
      StripeConnectService.release_payment_to_worker(@job)
      redirect_to @job, notice: 'Job marked as completed. Payment has been released. You can now leave a review.'
    else
      redirect_to @job, alert: 'Job cannot be completed unless it is covered.'
    end
  end

  private

  def set_job
    @job = Job.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to jobs_path, alert: 'Job not found.'
  end

  def authorize_opener!
    unless @job.opener == current_user
      redirect_to jobs_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def authorize_business!
    redirect_to jobs_path, alert: 'Only businesses can perform this action.' unless current_user.business?
  end

  def authorize_employee!
    redirect_to jobs_path, alert: 'Only employees can cover shifts.' unless current_user.employee?
  end

  def job_params
    params.require(:job).permit(
      :shift_date,
      :shift_started_at,
      :shift_ended_at,
      :location_address,
      :description,
      :job_type_id,
      :hourly_pay,
      :image
    )
  end
end
