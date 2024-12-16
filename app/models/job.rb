# == Schema Information
#
# Table name: jobs
#
#  id                :bigint           not null, primary key
#  company_name      :string
#  description       :text
#  location_address  :string
#  person_of_contact :string
#  phone_number      :string
#  shift_date        :date
#  shift_ended_at    :datetime
#  shift_started_at  :datetime
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cover_id          :bigint
#  job_type_id       :bigint           not null
#  opener_id         :bigint           not null
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
  belongs_to :job_type
  belongs_to :cover, class_name: 'User', foreign_key: 'cover_id', optional: true

  has_one_attached :image

  validates :shift_date, presence: true
  validates :shift_started_at, presence: true
  validates :shift_ended_at, presence: true
  validates :location_address, presence: true
  validates :description, presence: true
  validates :job_type_id, presence: true
  validates :company_name, presence: true
  validates :person_of_contact, presence: true
  validates :phone_number, presence: true
  # Remove validations for :location_name and :title

  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?

    unless image.byte_size <= 5.megabytes
      errors.add(:image, "is too big. Maximum size allowed is 5MB.")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG or PNG.")
    end
  end
end
