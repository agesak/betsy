require "test_helper"

describe CategoriesController do
  it "must get index" do
    get categories_index_url
    must_respond_with :success
  end

end
