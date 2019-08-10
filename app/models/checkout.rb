class Checkout
  attr_reader :total

  def initialize(promotional_rules)
    @promotional_rules = promotional_rules
    @total_price = 0
    @products_added = []
  end

  def scan(product)
    item_price = product.calculate_item_price(@products_added)
    @total_price += item_price
    @total = if @total_price >= @promotional_rules.min_total_price
               @total_price * (1 - @promotional_rules.discount_rate * 0.01)
             else
               @total_price
             end
    @total = @total.round(2)
  end
end
