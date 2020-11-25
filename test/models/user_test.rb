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

    describe 'merchant_orders by cart status' do
      it 'can return a hash with all of a current users related carts' do
        # key of the hash is the cart item, value is an array of the user's cartitems for that cart
        pending_orders = @user_ada.merchant_orders( "pending")
        user_product_ids = []

        # this user (:ada) has 3 products
        @user_ada.products.each do |product|
          user_product_ids << product.id
        end

        expect(pending_orders).must_be_kind_of Hash

        pending_orders.each do |cart, array|
          expect(cart).must_be_kind_of Cart

          array.each do |item|
            expect(user_product_ids.include? (item.product_id)).must_equal true
          end

        end
      end

      it 'will return an empty hash if user has no products in current carts' do
        Cart.all.each do |cart|
          cart.destroy
        end

        Cartitem.all.each do |item|
          item.destroy
        end

        pending_orders = @user_ada.merchant_orders( "pending")
        paid_orders = @user_ada.merchant_orders( "paid")
        complete_orders = @user_ada.merchant_orders( "complete")

        expect(pending_orders).must_be_kind_of Hash

        expect(pending_orders).must_be_empty
        expect(paid_orders).must_be_empty
        expect(complete_orders).must_be_empty
      end
    end

    describe 'revenue' do
      it 'will return revenue by cart status for the current user' do
        pending_revenue = @user_ada.revenue("pending")
        paid_revenue = @user_ada.revenue("paid")
        complete_revenue = @user_ada.revenue("complete")

        if pending_revenue == 0
          expect(pending_revenue).must_equal 0
        else
          expect(pending_revenue).must_be_kind_of Float
        end

        if paid_revenue == 0
          expect(paid_revenue).must_equal 0
        else
          expect(paid_revenue).must_be_kind_of Float
        end

        if complete_revenue == 0
          expect(complete_revenue).must_equal 0
        else
          expect(complete_revenue).must_be_kind_of Float
        end

        total_by_cartitems = 0
        @user_ada.cartitems.each do |item|
          total_by_cartitems += (item.cost * item.qty)
        end

        total_by_revenue = pending_revenue + paid_revenue + complete_revenue

        expect(total_by_cartitems == total_by_revenue).must_equal true
      end

      it 'will return 0 if no carts/cartitems' do
        Cart.all.each do |cart|
          cart.destroy
        end

        Cartitem.all.each do |item|
          item.destroy
        end

        pending_revenue = @user_ada.revenue("pending")
        paid_revenue = @user_ada.revenue("paid")
        complete_revenue = @user_ada.revenue("complete")

        expect(pending_revenue).must_equal 0
        expect(paid_revenue).must_equal 0
        expect(complete_revenue).must_equal 0

      end
    end

    describe 'item count' do
      it 'will return the number of user cartitems based on cart status' do
        total_cartitems = @user_ada.cartitems.count

        pending_items_count = @user_ada.item_count("pending")
        paid_items_count = @user_ada.item_count("paid")
        complete_items_count = @user_ada.item_count("complete")

        expect(pending_items_count).must_be_kind_of Integer
        expect(paid_items_count).must_be_kind_of Integer
        expect(complete_items_count).must_be_kind_of Integer

        total_by_status = pending_items_count + paid_items_count + complete_items_count

        expect(total_by_status == total_cartitems).must_equal true
      end

      it 'will return 0 if no cartitems' do
        Cart.all.each do |cart|
          cart.destroy
        end

        Cartitem.all.each do |item|
          item.destroy
        end

        pending_items_count = @user_ada.item_count("pending")
        paid_items_count = @user_ada.item_count("paid")
        complete_items_count = @user_ada.item_count("complete")

        expect(pending_items_count).must_equal 0
        expect(paid_items_count).must_equal 0
        expect(complete_items_count).must_equal 0
      end
    end
  end
end
