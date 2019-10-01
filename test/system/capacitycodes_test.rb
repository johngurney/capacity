require "application_system_test_case"

class CapacitycodesTest < ApplicationSystemTestCase
  setup do
    @capacitycode = capacitycodes(:one)
  end

  test "visiting the index" do
    visit capacitycodes_url
    assert_selector "h1", text: "Capacitycodes"
  end

  test "creating a Capacitycode" do
    visit capacitycodes_url
    click_on "New Capacitycode"

    fill_in "Number", with: @capacitycode.number
    fill_in "Text", with: @capacitycode.text
    click_on "Create Capacitycode"

    assert_text "Capacitycode was successfully created"
    click_on "Back"
  end

  test "updating a Capacitycode" do
    visit capacitycodes_url
    click_on "Edit", match: :first

    fill_in "Number", with: @capacitycode.number
    fill_in "Text", with: @capacitycode.text
    click_on "Update Capacitycode"

    assert_text "Capacitycode was successfully updated"
    click_on "Back"
  end

  test "destroying a Capacitycode" do
    visit capacitycodes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Capacitycode was successfully destroyed"
  end
end
