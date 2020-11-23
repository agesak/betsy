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
    it'has many products' do
      gear = Category.find_by(name: 'gear')

      # p gear.products
      # expect(gear.products.length > 1).must_equal true

    end

    it 'a product can be added to a category' do

    end
  end



end
