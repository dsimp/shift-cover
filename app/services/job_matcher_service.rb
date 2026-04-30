class JobMatcherService
  def self.recommended_employees_for(job)
    return [] unless job.job_type_id

    # Find employees who have the required certification, 
    # are not currently covering the job, 
    # and roughly match the city. 
    # Order them by their average rating (highest first).
    
    # Extract city from "123 Cafe Street, Chicago, IL" -> "Chicago" (simplified heuristic)
    city_heuristic = job.location_address.to_s.split(',').last(2).first.to_s.strip
    
    User.employee
        .where.not(id: job.cover_id)
        .joins(:user_job_types)
        .where(user_job_types: { job_type_id: job.job_type_id })
        .where("users.location ILIKE ?", "%#{city_heuristic}%")
        .sort_by { |u| -u.average_rating } # sort in Ruby since average_rating is a ruby method
        .first(5)
  end
end
