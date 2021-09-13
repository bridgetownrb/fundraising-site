class Fundraising < SiteBuilder
  def build
    hook :site, :pre_render do
      site.data.funding.percentage =
        [
          [
            ((site.data.funding.current.to_f / site.data.funding.goal.to_f) * 100).ceil,
            12
          ].max,
          100
        ].min
    end
  end
end
