class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: [:show, :edit, :update, :destroy, :cover]
  before_action :authorize_opener!, only: [:edit, :update, :destroy]

  # GET /jobs
  def index
    @jobs = if params[:filter] == 'eligible'
              current_user.eligible_jobs
            elsif params[:filter] == 'ineligible'
              current_user.ineligible_jobs
            else
              Job.where(cover_id: nil)
            end
  end

  # GET /jobs/new
  def new
    @job = current_user.posted_jobs.new
  end

  # POST /jobs
  def create
    @job = current_user.posted_jobs.new(job_params)

    if @job.save
      redirect_to @job, notice: 'Job was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /jobs/:id
  def show
    # @job is set by set_job
  end

  # GET /jobs/:id/edit
  def edit
    # @job is set by set_job
  end

  # PATCH/PUT /jobs/:id
  def update
    if @job.update(job_params)
      redirect_to @job, notice: 'Job was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /jobs/:id
  def destroy
    @job.destroy
    redirect_to jobs_url, notice: 'Job was successfully deleted.'
  end

  # POST /jobs/:id/cover
  def cover
    if current_user.has_profession?(@job.job_type)
      if @job.cover.present?
        redirect_to @job, alert: 'Job has already been covered.'
      else
        @job.update(cover: current_user)
        redirect_to @job, notice: 'You have successfully covered this job.'
      end
    else
      redirect_to training_module_job_type_path(@job.job_type), alert: 'You need to complete the training module to cover this job.'
    end
  end

  private

  # Set @job for specific actions
  def set_job
    @job = Job.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to jobs_path, alert: 'Job not found.'
  end

  # Authorize that the current user is the opener of the job
  def authorize_opener!
    unless @job.opener == current_user
      redirect_to jobs_path, alert: 'You are not authorized to perform this action.'
    end
  end

  # Only allow a list of trusted parameters through.
  def job_params
    params.require(:job).permit(
      :shift_date,
      :shift_started_at,
      :shift_ended_at,
      :location_address,
      :description,
      :job_type_id,
      :company_name,
      :person_of_contact,
      :phone_number,
      :image
    )
  end
end
