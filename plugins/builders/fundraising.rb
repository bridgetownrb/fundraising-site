class Fundraising < SiteBuilder
  def build
    hook :site, :pre_render do
      site.data.funding.percentage =
        [
          [
            ((site.data.funding.current.to_f / site.data.funding.goal.to_f) * 100).ceil,
            15
          ].max,
          100
        ].min

      site.data.STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']
      site.data.PAYPAL_CLIENT_ID = ENV['PAYPAL_CLIENT_ID']
    end
  end
end
