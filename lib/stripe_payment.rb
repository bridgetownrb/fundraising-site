require "stripe"
Stripe.api_key = ENV["STRIPE_API_KEY"]

module StripePayment
  def self.intent(dollars:)
    Stripe::PaymentIntent.create(
      amount: dollars * 100,
      currency: "usd",
      metadata: {
        purpose: "Bridgetown Fundraising",
      },
    )
  end
end
