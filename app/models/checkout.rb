class Checkout
  attr_reader :total

  def initialize(promotional_rules)
    @min_total_price = promotional_rules.min_total_price
    @discount_rate = promotional_rules.discount_rate
    @includes_discount_item = promotional_rules.includes_discount_item
    @total_price = 0
    @products_added = Array.new
  end

  def scan(product)
      item_price = product.calculate_item_price(@products_added, @includes_discount_item)
      @total_price += item_price
      @total = if @total_price >= @min_total_price
                 @total_price * (1 - @discount_rate * 0.01)
               else
                 @total_price
               end
      @total = @total.round(2)
  end
end