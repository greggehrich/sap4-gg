require 'test_helper'

class HoteljunksControllerTest < ActionController::TestCase
  setup do
    @hoteljunk = hoteljunks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hoteljunks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hoteljunk" do
    assert_difference('Hoteljunk.count') do
      post :create, hoteljunk: { name: @hoteljunk.name }
    end

    assert_redirected_to hoteljunk_path(assigns(:hoteljunk))
  end

  test "should show hoteljunk" do
    get :show, id: @hoteljunk
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hoteljunk
    assert_response :success
  end

  test "should update hoteljunk" do
    patch :update, id: @hoteljunk, hoteljunk: { name: @hoteljunk.name }
    assert_redirected_to hoteljunk_path(assigns(:hoteljunk))
  end

  test "should destroy hoteljunk" do
    assert_difference('Hoteljunk.count', -1) do
      delete :destroy, id: @hoteljunk
    end

    assert_redirected_to hoteljunks_path
  end
end
