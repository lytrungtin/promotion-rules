# Checkout Products within Promotion

Our client is an online marketplace; here is a sample of some of the products available on the site:

```bash
Product code  | Name                   | Price
----------------------------------------------------------
001           | Lavender heart         | £9.25
002           | Personalised cufflinks | £45.00
003           | Kids T-shirt           | £19.95
```

This is just an example of products, your system should be ready to accept any kind of product.
Our marketing team wants to offer promotions as an incentive for our customers to purchase these items.
If you spend over £60, then you get 10% off of your purchase. If you buy 2 or more lavender hearts then the price drops to £8.50.
Our check-out can scan items in any order, and because our promotions will change, it needs to be flexible regarding our promotional rules.
The interface to our checkout looks like this (shown in Ruby):
```bash
co = Checkout.new(promotional_rules)
co.scan(item)
co.scan(item)
price = co.total
```

Test data
---------
```bash
Basket: 001,002,003
Total price expected: £66.78

Basket: 001,003,001
Total price expected: £36.95

Basket: 001,002,001,003
Total price expected: £73.76 
```

## Getting Started

Get the code. Clone this git repository and check out the latest release:
```bash
git clone https://github.com/trungtinhandsome/promotion_rules
cd promotion_rules
```    

### Prerequisites

Installing Rails with a specific version number.
```bash
gem install rspec
```  

### Installing
Install the required gems by running the following command in the project root directory:

```bash
bundle install
```

## Running the automated tests
Run this command below to run the automated tests. 

```
 rspec spec/models/product_spec.rb  
```

## Authors

* **Tin Lee** - *Initial work* - [TinLee](https://github.com/trungtinhandsome)
