require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	PRICE_ERROR_MESSAGE = "must be greater than or equal to 0.01"

	def get_product_with_price(price)
		product = Product.new(:title => "test product",
  						  :description => "test",
  						  :image_url => "url.jpg")
  		product.price = -1

  		return product
	end

	def get_product_with_image_url(image_url)
		product = Product.new(:title => "test product",
  						  :description => "test",
  						  :price => 1)
  		product.image_url = image_url

  		return product
	end


  test "product attributes must be not empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
 	assert product.errors[:price].any?
  	assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
  	product = get_product_with_price -1

  	assert product.invalid?
  	assert_equal PRICE_ERROR_MESSAGE,
  		product.errors[:price].join('; ')

  	product.price = 0
  	assert product.invalid?
  	assert_equal PRICE_ERROR_MESSAGE,
  		product.errors[:price].join('; ')

  	product.price = 1
  	assert product.valid?
  end

  test "image Url must be an Url" do
  	ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
http://a.b.c/x/y/z/fred.gif }
	bad = %w{ fred.doc fred.gif/more fred.gif.more }

	ok.each do |url|
		assert get_product_with_image_url(url).valid?
	end

	bad.each do |url|
		assert get_product_with_image_url(url).invalid?
	end
  end

  test "product name should be uniq" do
  	product = Product.new(:title => products(:ruby).title,
  						  :description => "222",
  						  :price => "1",
  						  :image_url => "fred.jpg")

	assert !product.save 
	assert_equal "has already been taken", product.errors[:title].join('; ')
  end
end
