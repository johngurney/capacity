require 'test_helper'

class CapacitycodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @capacitycode = capacitycodes(:one)
  end

  test "should get index" do
    get capacitycodes_url
    assert_response :success
  end

  test "should get new" do
    get new_capacitycode_url
    assert_response :success
  end

  test "should create capacitycode" do
    assert_difference('Capacitycode.count') do
      post capacitycodes_url, params: { capacitycode: { number: @capacitycode.number, text: @capacitycode.text } }
    end

    assert_redirected_to capacitycode_url(Capacitycode.last)
  end

  test "should show capacitycode" do
    get capacitycode_url(@capacitycode)
    assert_response :success
  end

  test "should get edit" do
    get edit_capacitycode_url(@capacitycode)
    assert_response :success
  end

  test "should update capacitycode" do
    patch capacitycode_url(@capacitycode), params: { capacitycode: { number: @capacitycode.number, text: @capacitycode.text } }
    assert_redirected_to capacitycode_url(@capacitycode)
  end

  test "should destroy capacitycode" do
    assert_difference('Capacitycode.count', -1) do
      delete capacitycode_url(@capacitycode)
    end

    assert_redirected_to capacitycodes_url
  end
end
