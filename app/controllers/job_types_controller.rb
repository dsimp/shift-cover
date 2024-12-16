# app/controllers/job_types_controller.rb

class JobTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job_type, only: [:show, :edit, :training_module, :take_quiz, :submit_quiz]

  def index
    @job_types = JobType.all
  end

  def show
    # If user has the profession, show a summary
    # If not, show a "Start Training" button
  end

  def training_module
    @learning_module = @job_type.learning_module
    # Show full module
  end

  def take_quiz
    redirect_to @job_type, notice: "You have already completed this training." and return if current_user.has_profession?(@job_type)

    @learning_module = @job_type.learning_module
    @questions = @learning_module.quiz_questions.includes(:quiz_options)
  end

  def submit_quiz
    @learning_module = @job_type.learning_module
    @questions = @learning_module.quiz_questions

    correct_count = 0
    @questions.each do |question|
      selected_option_id = params[:quiz][question.id.to_s].to_i
      selected_option = question.quiz_options.find(selected_option_id)
      correct_count += 1 if selected_option.correct
    end

    passing_score = (@questions.count * 0.8).ceil

    if correct_count >= passing_score
      current_user.user_job_types.find_or_create_by!(job_type: @job_type)
      redirect_to @job_type, notice: "Congratulations! You've completed the training and earned the #{@job_type.title} profession."
    else
      redirect_to take_quiz_job_type_path(@job_type), alert: "You scored #{correct_count}/#{@questions.count}. Review the material and try again."
    end
  end

  # Other actions (new, create, edit, update, destroy) if needed
  # ...

  private

  def set_job_type
    @job_type = JobType.find(params[:id])
  end
end
