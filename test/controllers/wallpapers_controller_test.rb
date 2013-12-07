require 'test_helper'

class WallpapersControllerTest < ActionController::TestCase
  setup do
    @wallpaper = wallpapers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wallpapers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wallpaper" do
    assert_difference('Wallpaper.count') do
      post :create, wallpaper: { image: @wallpaper.image, image_height: @wallpaper.image_height, image_width: @wallpaper.image_width, processing: @wallpaper.processing, purity: @wallpaper.purity, user_id: @wallpaper.user_id }
    end

    assert_redirected_to wallpaper_path(assigns(:wallpaper))
  end

  test "should show wallpaper" do
    get :show, id: @wallpaper
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wallpaper
    assert_response :success
  end

  test "should update wallpaper" do
    patch :update, id: @wallpaper, wallpaper: { image: @wallpaper.image, image_height: @wallpaper.image_height, image_width: @wallpaper.image_width, processing: @wallpaper.processing, purity: @wallpaper.purity, user_id: @wallpaper.user_id }
    assert_redirected_to wallpaper_path(assigns(:wallpaper))
  end

  test "should destroy wallpaper" do
    assert_difference('Wallpaper.count', -1) do
      delete :destroy, id: @wallpaper
    end

    assert_redirected_to wallpapers_path
  end
end
