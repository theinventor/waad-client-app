require 'test_helper'

class Auth::WaadControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get authorize" do
    get :authorize
    assert_response :success
  end

  test "should get callback" do
    get :callback
    assert_response :success
  end

  test "should get client" do
    get :client
    assert_response :success
  end

end
