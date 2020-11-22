require "test_helper"

describe CategoriesController do
  it "must get new" do
    skip
    get categories_new_path
    must_respond_with :success
  end

  it "must get create" do
    skip
    get categories_create_path
    must_respond_with :success
  end

end
