
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attributes = [
      :name, :location, :profile_picture, :role, :company_name, :person_of_contact, :phone_number,
      :date_of_birth, :ssn, :i9_document, :e_signature_timestamp,
      :agreed_to_worker_agreement, :consented_to_background_check, :acknowledged_safety_training,
      :consented_to_privacy_policy, :consented_to_tos,
      :ein, :agreed_to_client_services_agreement, :agreed_to_liability_waiver,
      :agreed_to_escrow_terms, :agreed_to_non_circumvention, :acknowledged_hazard_disclosure
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end
end
