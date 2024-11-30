class JobTypesController < ApplicationController
  before_action :set_job_type, only: %i[ show edit update destroy ]

  # GET /job_types or /job_types.json
  def index
    @job_types = JobType.all
  end

  # GET /job_types/1 or /job_types/1.json
  def show
  end

  # GET /job_types/new
  def new
    @job_type = JobType.new
  end

  # GET /job_types/1/edit
  def edit
  end

  # POST /job_types or /job_types.json
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

  # PATCH/PUT /job_types/1 or /job_types/1.json
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

  # DELETE /job_types/1 or /job_types/1.json
  def destroy
    @job_type.destroy!

    respond_to do |format|
      format.html { redirect_to job_types_url, notice: "Job type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_type
      @job_type = JobType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_type_params
      params.require(:job_type).permit(:title, :description, :training_module)
    end
end
