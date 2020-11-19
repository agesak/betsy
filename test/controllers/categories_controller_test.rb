require "test_helper"

describe CategoriesController do
  it "must get new" do
    get categories_new_url
    must_respond_with :success
  end

  it "must get create" do
    get categories_create_url
    must_respond_with :success
  end

end
