require "test_helper"

describe User do
  describe 'validations' do
    it 'is valid when all fields are present' do
      new_user = User.new(uid: '1111', username: 'new_user', provider: 'github', image: 'some string', email: 'test@test.com')

      status = new_user.valid?
      expect(status).must_equal true

      expect {
        new_user.save
      }.must_change 'User.count', 1

    end

    it 'is invalid if missing uid' do
      # this should be a model/validtions text
      user = User.new(uid: nil, username: 'new_user', provider: 'github', image: 'some string', email: 'test@test.com')

      expect(user.valid?).must_equal false
    end

    it 'is invalid if missing username' do
      # this should be a model/validtions text
      user = User.new(uid: '11111111', username: nil, provider: 'github', image: 'some string', email: 'test@test.com')

      expect(user.valid?).must_equal false
    end

    it 'is invalid if missing email' do
      user = users(:ada)
      user.email = nil

      expect(user.valid?).must_equal false

    end

    it 'is invalid if username is not unique' do
      user = User.new(uid: '11111111', username: 'ada', provider: 'github', image: 'some string', email: 'test@test.com')

      expect(user.valid?).must_equal false

    end

    it 'is invalid if email address is not unique' do
      user = User.new(uid: '11111111', username: 'new_name', provider: 'github', image: 'some string', email: 'ada@adadev.org')

      expect(user.valid?).must_equal false
    end

  end

  describe 'relations' do
    before do
      @user = users(:ada)
    end

    it 'can have many products' do
      #use fixtures yml data

      expect(@user.products.count).must_equal 3
    end

    it 'has many cartitems through products' do
      expect(@user.cartitems.count).must_equal 2
      #instead of equal 2, could do array = cartitems.where(:product_id ) is 1, 2, or 3 .length

      @user.cartitems.each do |item|
        expect(item).must_be_kind_of Cartitem
      end
    end
  end

  describe 'methods' do
    before do
      @user_ada = users(:ada)
    end

    it 'can find all merchants (users w/ > 0 products)' do
      # merchants are users with > 0 products
      merchants = User.merchants

      expect(merchants).must_be_kind_of Array
      merchants.each do |merchant|
        expect(merchant.products.length > 0 ).must_equal true
        expect(merchant).must_be_kind_of User
      end
    end

    it 'can return a hash with all of a current users related carts' do
      # key of the hash is the cart id, value is the Cart object
      pending_orders = @user_ada.merchant_orders( status = "pending")
      user_product_ids = []

      # this user (:ada) has 3 products
      @user_ada.products.each do |product|
        user_product_ids << product.id
      end

      expect(pending_orders).must_be_kind_of Hash

      pending_orders.each do |cart_id, cart|
        expect(cart).must_be_kind_of Cart
        expect(cart.id == cart_id).must_equal true

        # Set up for: expecting that of the cartitems in the selected cart, must include at least one of the user's products
        is_user_product = [] # an array of boolean values
        cart.cartitems.each do |item|
          user_product_ids.include? (item.product_id) ? (is_user_product << true) : (is_user_product << false)
        end

        expect(is_user_product.include? (true)).must_equal true
      end
    end

    it 'will return an empty hash if user has no products in current carts' do
      skip
      # not working, 'undefined method 'merchant_orders' for nil class
      Cart.all.each do |cart|
        cart.destroy
      end

      Cartitem.all.each do |item|
        item.destroy
      end

      pending_orders = @user.merchant_orders( status = "pending")
      p pending_orders

      expect(@user).must_be_kind_of User

      expect(pending_orders).must_be_kind_of Hash

      #expect(pending_orders).must_be_empty
    end
  end
end
