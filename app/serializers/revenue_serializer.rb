class RevenueSerializer
  def self.revenue(data)
    {
      data: {
        attributes: {
          revenue: data.to_s
        }
      }
    }
  end

end
