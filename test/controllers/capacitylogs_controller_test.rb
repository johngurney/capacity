require 'test_helper'

class CapacitylogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @capacitylog = capacitylogs(:one)
  end

  test "should get index" do
    get capacitylogs_url
    assert_response :success
  end

  test "should get new" do
    get new_capacitylog_url
    assert_response :success
  end

  test "should create capacitylog" do
    assert_difference('Capacitylog.count') do
      post capacitylogs_url, params: { capacitylog: { capacitycode: @capacitylog.capacitycode, comment: @capacitylog.comment, user_id: @capacitylog.user_id } }
    end

    assert_redirected_to capacitylog_url(Capacitylog.last)
  end

  test "should show capacitylog" do
    get capacitylog_url(@capacitylog)
    assert_response :success
  end

  test "should get edit" do
    get edit_capacitylog_url(@capacitylog)
    assert_response :success
  end

  test "should update capacitylog" do
    patch capacitylog_url(@capacitylog), params: { capacitylog: { capacitycode: @capacitylog.capacitycode, comment: @capacitylog.comment, user_id: @capacitylog.user_id } }
    assert_redirected_to capacitylog_url(@capacitylog)
  end

  test "should destroy capacitylog" do
    assert_difference('Capacitylog.count', -1) do
      delete capacitylog_url(@capacitylog)
    end

    assert_redirected_to capacitylogs_url
  end
end
