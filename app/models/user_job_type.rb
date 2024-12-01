# == Schema Information
#
# Table name: user_job_types
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  job_type_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_user_job_types_on_job_type_id  (job_type_id)
#  index_user_job_types_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_type_id => job_types.id)
#  fk_rails_...  (user_id => users.id)
#
class UserJobType < ApplicationRecord
  belongs_to :user
  belongs_to :job_type
end
