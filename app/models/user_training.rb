# == Schema Information
#
# Table name: user_trainings
#
#  id           :bigint           not null, primary key
#  completed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  job_type_id  :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_user_trainings_on_job_type_id  (job_type_id)
#  index_user_trainings_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_type_id => job_types.id)
#  fk_rails_...  (user_id => users.id)
#
# app/models/user_training.rb
class UserTraining < ApplicationRecord
  belongs_to :user
  belongs_to :job_type

  validates :user_id, uniqueness: { scope: :job_type_id }
end
