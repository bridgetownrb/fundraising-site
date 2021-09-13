require_relative "../../lib/stripe_payment"

class Routes::Payments < Bridgetown::Rack::Routes
  route do |r|
    r.post "payment_intents" do |name|
      # Create a PaymentIntent with amount and currency
      payment_intent = StripePayment.intent(dollars: r.params[:amount].to_i)

      p payment_intent

      {
        clientSecret: payment_intent["client_secret"],
      }
    end
  end
end
