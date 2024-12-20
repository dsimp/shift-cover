
class NotifyUsersOfNewJob
  def initialize(job)
    @job = job
  end

  def call
    eligible_users.each do |user|
      send_notification(user)
    end
  end

  private

  def eligible_users
    # Users who are trained in the job type
    User.joins(:user_job_types).where(user_job_types: { job_type_id: @job.job_type_id })
  end

  def send_notification(user) # Can't wait to see this in action once you cofigure mailer
    # Example: Using ActionMailer or other notification services
    UserMailer.new_job_notification(user, @job).deliver_now
  rescue StandardError => e
    Rails.logger.error("Failed to notify user #{user.id}: #{e.message}")
  end
end
