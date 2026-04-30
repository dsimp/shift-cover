# == Schema Information
#
# Table name: users
#
#  id                                  :bigint           not null, primary key
#  acknowledged_hazard_disclosure      :boolean          default(FALSE)
#  acknowledged_safety_training        :boolean          default(FALSE)
#  agreed_to_client_services_agreement :boolean          default(FALSE)
#  agreed_to_escrow_terms              :boolean          default(FALSE)
#  agreed_to_liability_waiver          :boolean          default(FALSE)
#  agreed_to_non_circumvention         :boolean          default(FALSE)
#  agreed_to_worker_agreement          :boolean          default(FALSE)
#  company_name                        :string
#  consented_to_background_check       :boolean          default(FALSE)
#  consented_to_privacy_policy         :boolean          default(FALSE)
#  consented_to_tos                    :boolean          default(FALSE)
#  date_of_birth                       :date
#  e_signature_timestamp               :datetime
#  ein                                 :string
#  email                               :citext           default(""), not null
#  encrypted_password                  :string           default(""), not null
#  location                            :string
#  name                                :citext
#  person_of_contact                   :string
#  phone_number                        :string
#  remember_created_at                 :datetime
#  reset_password_sent_at              :datetime
#  reset_password_token                :string
#  role                                :integer          default("employee")
#  ssn                                 :string
#  subscription_expires_at             :datetime
#  subscription_tier                   :integer          default("free")
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  stripe_account_id                   :string
#  stripe_customer_id                  :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_name                  (name) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { employee: 0, business: 1, admin: 2 }
  enum subscription_tier: { free: 0, starter: 1, growth: 2 }

  has_many :posted_jobs, class_name: 'Job', foreign_key: 'opener_id', dependent: :destroy
  has_many :covered_jobs, class_name: 'Job', foreign_key: 'cover_id'
  has_many :jobs_as_opener, class_name: "Job", foreign_key: :opener_id
  has_many :jobs_as_cover, class_name: "Job", foreign_key: :cover_id

  has_many :user_job_types, dependent: :destroy
  has_many :job_types, through: :user_job_types
  has_many :user_trainings, dependent: :destroy
  has_many :completed_job_types, through: :user_trainings, source: :job_type

  has_many :given_reviews, class_name: 'Review', foreign_key: 'reviewer_id', dependent: :destroy
  has_many :received_reviews, class_name: 'Review', foreign_key: 'reviewee_id', dependent: :destroy

  has_one_attached :profile_picture
  has_one_attached :i9_document

  encrypts :ssn
  encrypts :ein

  validates :name, presence: true, uniqueness: true

  with_options if: -> { employee? } do
    validates :date_of_birth, presence: true, on: :create
    validates :ssn, presence: true, on: :create
    validates :location, presence: true, on: :create
    validates :agreed_to_worker_agreement, acceptance: { accept: [true, '1', 1] }, on: :create
    validates :consented_to_background_check, acceptance: { accept: [true, '1', 1] }, on: :create
    validates :acknowledged_safety_training, acceptance: { accept: [true, '1', 1] }, on: :create
    validates :consented_to_privacy_policy, acceptance: { accept: [true, '1', 1] }, on: :create
    validates :consented_to_tos, acceptance: { accept: [true, '1', 1] }, on: :create
  end

  with_options if: -> { business? } do
    validates :company_name, presence: true, on: :create
    validates :person_of_contact, presence: true, on: :create
    validates :phone_number, presence: true, on: :create
    validates :ein, presence: true, on: :create
    validates :agreed_to_client_services_agreement, acceptance: { accept: [true, '1', 1] }, on: :create
    validates :agreed_to_liability_waiver, acceptance: { accept: [true, '1', 1] }, on: :create
    validates :agreed_to_escrow_terms, acceptance: { accept: [true, '1', 1] }, on: :create
    validates :agreed_to_non_circumvention, acceptance: { accept: [true, '1', 1] }, on: :create
    validates :acknowledged_hazard_disclosure, acceptance: { accept: [true, '1', 1] }, on: :create
  end

  validate :acceptable_image


  def acceptable_image
    return unless profile_picture.attached?

    unless profile_picture.byte_size <= 1.megabyte
      errors.add(:profile_picture, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(profile_picture.content_type)
      errors.add(:profile_picture, "must be a JPEG or PNG")
    end
  end

  def has_profession?(job_type)
    job_types.exists?(job_type.id)
  end

  def eligible_jobs
    Job.where(cover_id: nil, job_type_id: job_types.ids)
  end

  def ineligible_jobs
    Job.where(cover_id: nil).where.not(job_type_id: job_types.ids)
  end 

  def average_rating
    return 0 if received_reviews.empty?
    received_reviews.average(:rating).to_f.round(1)
  end

  def stripe_account?
    stripe_account_id.present?
  end

  def active_subscription?
    subscription_expires_at.present? && subscription_expires_at > Time.current
  end
  
  after_create :send_welcome_email



  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
