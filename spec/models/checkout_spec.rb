require_relative '../../app/models/product.rb'
require_relative '../../app/models/promotion.rb'
require_relative '../../app/models/checkout.rb'

describe Checkout do
  before do
    @promotional_rules = Promotion.new(min_total_price: 61, discount_rate: 10)
    @co = Checkout.new(@promotional_rules)
  end

  describe '#scan' do
    context 'When items have price discount from product' do
      before do
        @item_has_discount = Product.new(price: 20.75, quantity_discount: 3, price_discount: 15.5)
        @i = 0
      end

      context 'When total checkout less than min total price discount' do
        context 'When buy items is not enough quantity discount' do
          before do
            @quantity = @item_has_discount.quantity_discount - 1
          end
          it 'It should be not applied discount' do
            begin
              @co.scan(@item_has_discount)
              @i += 1
            end while @i < @quantity
            price_from_item_discount = @item_has_discount.price * @quantity
            expect(price_from_item_discount).to be < @promotional_rules.min_total_price
            expect(@co.total).to eq price_from_item_discount
          end
        end

        context 'When buy items is enough quantity discount' do
          before do
            @quantity = @item_has_discount.quantity_discount
          end
          it 'It should applied discount from product' do
            begin
              @co.scan(@item_has_discount)
              @i += 1
            end while @i < @quantity
            price_from_item_discount = @item_has_discount.price_discount * @quantity
            expect(price_from_item_discount).to be < @promotional_rules.min_total_price
            expect(@co.total).to eq price_from_item_discount
          end
        end
      end

      context 'When total checkout equal min total price discount' do
        context 'When buy items is not enough quantity discount' do
          before do
            @quantity = @item_has_discount.quantity_discount - 1
          end

          it 'It should be not applied discount from product but applied from promotion' do
            begin
              @co.scan(@item_has_discount)
              @i += 1
            end while @i < @quantity
            price_from_item_discount = @item_has_discount.price * @quantity
            item_no_discount = Product.new(price: 61 - @co.total)
            @co.scan(item_no_discount)
            total_price_expected_before_discount = price_from_item_discount + item_no_discount.price
            expect(total_price_expected_before_discount).to eq @promotional_rules.min_total_price
            total_expected = total_price_expected_before_discount * (1 - @promotional_rules.discount_rate.to_f / 100)
            expect(@co.total).to eq total_expected
          end
        end

        context 'When buy items is enough quantity discount' do
          before do
            @quantity = @item_has_discount.quantity_discount
          end

          it 'It should be applied discount from both product and promotion' do
            begin
              @co.scan(@item_has_discount)
              @i += 1
            end while @i < @quantity
            price_from_item_discount = @item_has_discount.price_discount * @quantity
            item_no_discount = Product.new(price: 61 - @co.total)
            @co.scan(item_no_discount)
            total_price_expected_before_discount = price_from_item_discount + item_no_discount.price
            expect(total_price_expected_before_discount).to eq @promotional_rules.min_total_price
            total_expected = total_price_expected_before_discount * (1 - @promotional_rules.discount_rate.to_f / 100)
            expect(@co.total).to eq total_expected
          end
        end
      end
    end
  end

  describe 'Integrate sample tests' do
    before do
      / If you buy 2 or more lavender hearts then the price drops to £8.50 /
      @item_001 = Product.new(product_code: '001', name: 'Lavender heart',
                           price: 9.25, quantity_discount: 2, price_discount: 8.5)

      @item_002 = Product.new(product_code: '002', name: 'Personalised cufflinks', price: 45.00)
      @item_003 = Product.new(product_code: '003', name: 'Kids T-shirt', price: 19.95)

      / If you spend over £60, then you get 10% off of your purchase /
    end

    context 'If you buy 2 or more lavender hearts then the price drops to £8.50' do
      it 'It should be applied discount from product' do
        @co.scan(@item_001)
        @co.scan(@item_001)
        expect(@co.total).to eq @item_001.price_discount * 2
      end
    end

    context 'If you spend over £60, then you get 10% off of your purchase' do
      it 'It should be applied discount from promotion' do
        @co.scan(@item_002)
        @co.scan(@item_002)
        expect(@co.total).to eq (@item_002.price * 2) * 0.9
      end
    end

    context 'When input sample test data' do
      context 'When Basket: 001,002,003' do
        it 'should return total price: £66.78' do
          [@item_001, @item_002, @item_003].each do |item|
            @co.scan(item)
          end
          expect(@co.total).to eq 66.78
        end
      end
      context 'When Basket: 001,003,001' do
        it 'should return total price: £36.95' do
          [@item_001, @item_003, @item_001].each do |item|
            @co.scan(item)
          end
          expect(@co.total).to eq 36.95
        end
      end
      context 'When Basket: 001,002,001,003' do
        it 'should return total price: £73.76' do
          [@item_001, @item_002, @item_001, @item_003].each do |item|
            @co.scan(item)
          end
          expect(@co.total).to eq 73.76
        end
      end
    end
  end
end
