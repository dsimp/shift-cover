# == Schema Information
#
# Table name: learning_modules
#
#  id          :bigint           not null, primary key
#  content     :text
#  quiz        :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  job_type_id :bigint           not null
#
# Indexes
#
#  index_learning_modules_on_job_type_id  (job_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_type_id => job_types.id)
#
class LearningModule < ApplicationRecord
  belongs_to :job_type

  validates :content, presence: true
  validates :quiz, presence: true
end
