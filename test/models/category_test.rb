require "test_helper"

describe Category do
  describe 'validations' do
    it 'is valid with unique name' do
      category = Category.new(name: 'Joggers')
      expect(category.valid?).must_equal true

      gear = Category.find_by(name: 'gear')
      expect(gear.valid?).must_equal true
    end

    it 'is invalid without a name' do
      category = Category.new(name: nil)

      expect(category.valid?).must_equal false
    end

    it 'is invalid if name is not unique' do
      category = Category.new(name: 'gear')

      expect(category.valid?).must_equal false
    end
  end

  describe 'relations' do
    before do
      @ada = users(:ada)
      @gear = categories(:category_gear)
    end

    it 'can have many products' do
      @ada.products.each do |product|
        product.categories << @gear
      end

      expect(@gear.products.length > 1).must_equal true

    end

    it 'can add a product to a category' do
      product = @ada.products[0]
      @gear.products << product

      expect(@gear.products.length == 1).must_equal true
    end
  end
end
