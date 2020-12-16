class RevenueSerializer
  def self.revenue(data)
    {
      data: {
        attributes: {
          revenue: data.round(2)
        }
      }
    }
  end

end
