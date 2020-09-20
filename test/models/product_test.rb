require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  # test "the truth" do
  #   assert true
  # end
  #

  def new_product(image_url)
    product = Product.new(
        title: 'My Book title',
        description: 'yyy',
        price: 0.01,
        image_url: image_url
    )
  end

  test "product 属性不能为空" do
    product = Product.new
    assert product.invalid?

    assert product.errors[:title].any?
  end

  test "product 价格必须为正数" do
    product = new_product('zzz.jpg')

    product.price = -1
    assert product.invalid?

    product.price = 0
    assert product.invalid?

    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test "image url" do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif}

    bad = %w{fred.doc fred.gif/more fred.gif.more}

    ok.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url}不应该无效"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url}不应该有效"
    end
  end

  test "product 标题应该唯一" do
    product = Product.new(
        title: products(:ruby).title,
        description: "yyy",
        price: 1,
        image_url: "fred.gif"
    )
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
end
