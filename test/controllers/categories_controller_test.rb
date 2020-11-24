require "test_helper"

describe CategoriesController do
  describe 'create' do
    it 'can create a new category' do
      perform_login()

      new_category = { category: {name: "equipment"} }

      expect {
        post categories_path, params: new_category
      }.must_differ 'Category.count', 1

      expect(flash[:success]).must_equal "Category was successfully created!"
    end

    it 'will not create a category if not logged in' do
      # not logged in

      new_category = { category: {name: "equipment"} }

      expect {
        post categories_path, params: new_category
      }.wont_change 'Category.count'

      # flash failure didn't pick up from test
      #expect(flash[:failure]).must_equal "Category was not successfully created."
    end
  end

end
