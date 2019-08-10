class Promotion
  attr_accessor :min_total_price, :discount_rate, :includes_discount_item

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end