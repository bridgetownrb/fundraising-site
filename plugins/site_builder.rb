require "dotenv/load" unless Bridgetown.env.production?
require_relative "../lib/stripe_payment"

class SiteBuilder < Bridgetown::Builder
  # write builders which subclass SiteBuilder in plugins/builders
end
