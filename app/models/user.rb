# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  location               :string
#  name                   :citext
#  password               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
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

  has_many :posted_jobs, class_name: 'Job', foreign_key: 'opener_id', dependent: :destroy
  has_many :covered_jobs, class_name: 'Job', foreign_key: 'cover_id'

  has_many :user_job_types, dependent: :destroy
  has_many :job_types, through: :user_job_types
  has_many :user_trainings, dependent: :destroy
  has_many :completed_job_types, through: :user_trainings, source: :job_type

  has_one_attached :profile_picture

  validates :name, presence: true, uniqueness: true

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
  
  after_create :send_welcome_email



  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
