require "test_helper"

describe Category do
  it "can have a banner image" do
    gear = categories(:category_gear)
    gear.banner_img = "http://lorempixel.com/1440/360/food"
    expect(gear.valid?).must_equal true
  end

  it "can be instantiated without a banner image" do
    gear = Category.create(name: "pets", banner_img: nil)
    expect(gear.valid?).must_equal true
  end
end
