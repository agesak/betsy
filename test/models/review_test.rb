require "test_helper"

describe Review do
  describe "relations" do
    it 'has a product' do
      r = reviews(:review1)
      expect(r).must_respond_to :product
      expect(r.product).must_be_kind_of Product
    end

  end
end
