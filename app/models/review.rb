# == Schema Information
#
# Table name: reviews
#
#  id          :bigint           not null, primary key
#  comment     :text
#  rating      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  job_id      :bigint           not null
#  reviewee_id :bigint           not null
#  reviewer_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_job_id       (job_id)
#  index_reviews_on_reviewee_id  (reviewee_id)
#  index_reviews_on_reviewer_id  (reviewer_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (reviewee_id => users.id)
#  fk_rails_...  (reviewer_id => users.id)
#
class Review < ApplicationRecord
  belongs_to :job
  belongs_to :reviewer, class_name: 'User'
  belongs_to :reviewee, class_name: 'User'

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, if: -> { rating.present? && rating <= 3 }
end
