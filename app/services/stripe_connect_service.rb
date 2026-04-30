class StripeConnectService
  def self.create_account_link(user)
    return unless user.business?

    begin
      account = Stripe::Account.create({
        type: 'express',
        country: 'US',
        email: user.email,
        capabilities: { transfers: { requested: true } }
      })
      user.update!(stripe_account_id: account.id)

      # Rails.application.routes.url_helpers could be used, but hardcoding for simplicity as requested
      link = Stripe::AccountLink.create({
        account: account.id,
        refresh_url: "http://localhost:3000/",
        return_url: "http://localhost:3000/",
        type: 'account_onboarding'
      })
      link.url
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: #{e.message}"
      nil
    end
  end

  def self.create_escrow_payment(job, amount_cents)
    begin
      intent = Stripe::PaymentIntent.create({
        amount: amount_cents,
        currency: 'usd',
        payment_method_types: ['card'],
        transfer_group: "job_#{job.id}",
        metadata: { job_id: job.id }
      })
      job.update!(payment_intent_id: intent.id)
      intent
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: #{e.message}"
      nil
    end
  end

  def self.release_payment_to_worker(job)
    return false unless job.escrow_payment_completed? && job.cover&.stripe_account_id

    begin
      # Calculate amount based on hours worked
      duration_hours = (job.shift_ended_at - job.shift_started_at) / 3600.0
      amount_cents = (job.hourly_pay * duration_hours * 100).to_i

      Stripe::Transfer.create({
        amount: amount_cents,
        currency: 'usd',
        destination: job.cover.stripe_account_id,
        source_transaction: job.payment_intent_id
      })
      job.update!(payout_status: :paid)
      true
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: #{e.message}"
      job.update!(payout_status: :failed)
      false
    end
  end
end
