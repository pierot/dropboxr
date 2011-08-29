require 'test_helper'

class BuildControllerTest < ActionController::TestCase
  test "should get building" do
    get :building
    assert_response :success
  end

  test "should get done" do
    get :done
    assert_response :success
  end

  test "should get error" do
    get :error
    assert_response :success
  end

end
