# == Schema Information
#
# Table name: jobs
#
#  id               :bigint           not null, primary key
#  description      :text
#  location_address :string
#  location_name    :string
#  shift_date       :date
#  shift_ended_at   :datetime
#  shift_started_at :datetime
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  cover_id         :bigint           not null
#  job_type_id      :bigint           not null
#  opener_id        :bigint           not null
#
# Indexes
#
#  index_jobs_on_cover_id     (cover_id)
#  index_jobs_on_job_type_id  (job_type_id)
#  index_jobs_on_opener_id    (opener_id)
#
# Foreign Keys
#
#  fk_rails_...  (cover_id => users.id)
#  fk_rails_...  (job_type_id => job_types.id)
#  fk_rails_...  (opener_id => users.id)
#
class Job < ApplicationRecord
  belongs_to :opener, class_name: 'User', foreign_key: 'opener_id'
  belongs_to :cover, class_name: 'User', foreign_key: 'cover_id', optional: true
  belongs_to :job_type
end
