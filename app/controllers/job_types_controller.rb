class JobTypesController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_job_type, only: %i[ show edit update destroy training_module complete_training ]

  def index
    @job_types = JobType.all
  end

  def show
  end

  def new
    @job_type = JobType.new
  end

  def edit
  end

  def create
    @job_type = JobType.new(job_type_params)

    respond_to do |format|
      if @job_type.save
        format.html { redirect_to job_type_url(@job_type), notice: "Job type was successfully created." }
        format.json { render :show, status: :created, location: @job_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @job_type.update(job_type_params)
        format.html { redirect_to job_type_url(@job_type), notice: "Job type was successfully updated." }
        format.json { render :show, status: :ok, location: @job_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @job_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def training_module
    # @job_type is set by set_job_type
    # I can add additional logic or data here if needed
  end

  def complete_training
    unless current_user.has_profession?(@job_type)
      UserJobType.create!(user: current_user, job_type: @job_type)
    end
    redirect_to @job_type, notice: "You have gained the profession of #{@job_type.title}!"
  end

  def destroy
    @job_type.destroy

    respond_to do |format|
      format.html { redirect_to job_types_url, notice: "Job type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_job_type
      @job_type = JobType.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to job_types_path, alert: 'Job type not found.'
    end

    
    def authorize_job_type
      authorize @job_type || JobType
    end

    
    def job_type_params
      params.require(:job_type).permit(:title, :description, :training_module)
    end
end
