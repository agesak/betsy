require "application_system_test_case"

describe "Categories", :system do
  let(:category) { categories(:one) }

  it "visiting the index" do
    visit categories_url
    assert_selector "h1", text: "Categories"
  end

  it "creating a Category" do
    visit categories_url
    click_on "New Category"

    fill_in "Index", with: @category.index
    click_on "Create Category"

    assert_text "Category was successfully created"
    click_on "Back"
  end

  it "updating a Category" do
    visit categories_url
    click_on "Edit", match: :first

    fill_in "Index", with: @category.index
    click_on "Update Category"

    assert_text "Category was successfully updated"
    click_on "Back"
  end

  it "destroying a Category" do
    visit categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Category was successfully destroyed"
  end
end
