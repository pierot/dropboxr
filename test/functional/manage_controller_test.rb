require 'test_helper'

class ManageControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get rebuild" do
    get :rebuild
    assert_response :success
  end

end
