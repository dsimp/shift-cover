class Business::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_business!

  def create
    tier = params[:tier]
    
    # In a real app, these would be proper Stripe Price IDs from ENV variables.
    # We'll simulate a successful subscription update for demonstration.
    
    begin
      # Simulate Stripe Checkout Session creation
      if tier == "growth"
        current_user.update!(subscription_tier: :growth, subscription_expires_at: 1.month.from_now)
      else
        current_user.update!(subscription_tier: :starter, subscription_expires_at: 1.month.from_now)
      end
      
      redirect_to current_user, notice: "Successfully subscribed to the #{tier.capitalize} plan! (Simulated for testing)"
    rescue StandardError => e
      redirect_to pricing_path, alert: "Something went wrong: #{e.message}"
    end
  end

  private

  def authorize_business!
    unless current_user.business?
      redirect_to root_path, alert: "Only businesses can subscribe."
    end
  end
end
