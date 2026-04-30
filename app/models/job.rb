# == Schema Information
#
# Table name: jobs
#
#  id                :bigint           not null, primary key
#  description       :text
#  hourly_pay        :decimal(8, 2)
#  location_address  :string
#  payout_status     :integer          default("pending")
#  shift_date        :date
#  shift_ended_at    :datetime
#  shift_started_at  :datetime
#  status            :integer          default("open")
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cover_id          :bigint
#  job_type_id       :bigint           not null
#  opener_id         :bigint           not null
#  payment_intent_id :string
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

  has_many :reviews, dependent: :destroy

  enum status: { open: 0, covered: 1, in_progress: 2, completed: 3, cancelled: 4 }
  enum payout_status: { pending: 0, paid: 1, failed: 2 }, _prefix: :payout

  delegate :company_name, :person_of_contact, :phone_number, to: :opener, allow_nil: true

  has_one_attached :image

  validates :shift_date, presence: true
  validates :shift_started_at, presence: true
  validates :shift_ended_at, presence: true
  validates :location_address, presence: true
  validates :description, presence: true
  validates :job_type_id, presence: true
  validates :hourly_pay, presence: true, numericality: { greater_than: 0 }
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

  def escrow_payment_completed?
    payment_intent_id.present? && payout_paid?
  end
end
