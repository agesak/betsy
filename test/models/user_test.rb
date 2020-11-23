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

      #add a cart item
      #?????
    end
  end

  describe 'methods' do
    before do
      @user = users(:ada)
    end

    it 'can find all merchants (users w/ > 0 products)' do
      # merchants are users with > 0 products
      merchants = User.merchants

      merchants.each do |merchant|
        # Not sure why this doesn't work:
        # expect(merchant.products).must_be :>, 2
        expect(merchant).must_be_kind_of User
      end

      expect(merchants).must_be_kind_of Array
    end

    it 'can return a hash with all of a current users related carts' do
      pending_orders = @user.merchant_orders( status = "pending")

      # OK need to add some orders for this user!
      p pending_orders.length
      p pending_orders

      expect(pending_orders).must_be_kind_of Hash

      # Once there are orders
      # Expect pending_orders.first (I cant do that with a hash, right?  Or have to use pending_orders[1] ? ) .must_be_kind_of Cart
      # select that cart, that Cart must include cart items where the product is one of this user's products

    end

    it 'will return an empty hash if user has no currents carts' do
      pending_orders = @user.merchant_orders( status = "pending")

      expect(pending_orders).must_be_kind_of Hash
      expect(pending_orders).must_be_empty
    end
  end
end
