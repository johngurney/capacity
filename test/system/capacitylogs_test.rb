require "application_system_test_case"

class CapacitylogsTest < ApplicationSystemTestCase
  setup do
    @capacitylog = capacitylogs(:one)
  end

  test "visiting the index" do
    visit capacitylogs_url
    assert_selector "h1", text: "Capacitylogs"
  end

  test "creating a Capacitylog" do
    visit capacitylogs_url
    click_on "New Capacitylog"

    fill_in "Capacitycode", with: @capacitylog.capacitycode
    fill_in "Comment", with: @capacitylog.comment
    fill_in "User", with: @capacitylog.user_id
    click_on "Create Capacitylog"

    assert_text "Capacitylog was successfully created"
    click_on "Back"
  end

  test "updating a Capacitylog" do
    visit capacitylogs_url
    click_on "Edit", match: :first

    fill_in "Capacitycode", with: @capacitylog.capacitycode
    fill_in "Comment", with: @capacitylog.comment
    fill_in "User", with: @capacitylog.user_id
    click_on "Update Capacitylog"

    assert_text "Capacitylog was successfully updated"
    click_on "Back"
  end

  test "destroying a Capacitylog" do
    visit capacitylogs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Capacitylog was successfully destroyed"
  end
end
