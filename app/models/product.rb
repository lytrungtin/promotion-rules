class Product
  attr_accessor :product_code, :name, :price, :quantity_discount, :price_discount

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def calculate_item_price(products_added)
    products_added << product_code
    quantity = products_added.count(product_code)
    if quantity_discount && quantity >= quantity_discount.to_i
      total_price_discount = price_discount.to_f
      if quantity == quantity_discount.to_i # This is condition for action discount for item price has been scanned before.
        total_price_discount -= (price.to_f - price_discount.to_f) * (quantity - 1)
      end
      total_price_discount
    else
      price
    end
  end
end
