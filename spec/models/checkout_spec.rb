require_relative "../../app/models/product.rb"
require_relative "../../app/models/promotion.rb"
require_relative "../../app/models/checkout.rb"


describe Checkout do
  describe "total" do
    before do
      @item1 = Product.new(product_code: '001', name: 'Lavender heart', price: 9.25, quantity_discount: 2,
                          price_discount: 8.5)
      @item2 = Product.new(product_code: '002', name: 'Personalised cufflinks', price: 45.00, quantity_discount: nil,
                          price_discount: nil)
      @item3 = Product.new(product_code: '003', name: 'Kids T-shirt', price: 19.95, quantity_discount: nil,
                          price_discount: nil)
      @promotional_rules = Promotion.new(min_total_price: 60, discount_rate: 10, includes_discount_item: true)
    end

    it "Test 1" do
      co = Checkout.new(@promotional_rules)
      co.scan(@item1)
      co.scan(@item2)
      co.scan(@item3)
      price = co.total
      expect(price).to eq 66.78
    end

    it "Test 2" do
      co = Checkout.new(@promotional_rules)
      co.scan(@item1)
      co.scan(@item3)
      co.scan(@item1)
      price = co.total
      expect(price).to eq 36.95
    end

    it "Test 3" do
      co = Checkout.new(@promotional_rules)
      co.scan(@item1)
      co.scan(@item2)
      co.scan(@item1)
      co.scan(@item3)
      price = co.total
      expect(price).to eq 73.76
    end
  end
end
