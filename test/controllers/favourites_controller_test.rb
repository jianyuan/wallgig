require 'test_helper'

class FavouritesControllerTest < ActionController::TestCase
  setup do
    @favourite = favourites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favourites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favourite" do
    assert_difference('Favourite.count') do
      post :create, favourite: { collection_id: @favourite.collection_id, user_id: @favourite.user_id, wallpaper_id: @favourite.wallpaper_id }
    end

    assert_redirected_to favourite_path(assigns(:favourite))
  end

  test "should show favourite" do
    get :show, id: @favourite
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @favourite
    assert_response :success
  end

  test "should update favourite" do
    patch :update, id: @favourite, favourite: { collection_id: @favourite.collection_id, user_id: @favourite.user_id, wallpaper_id: @favourite.wallpaper_id }
    assert_redirected_to favourite_path(assigns(:favourite))
  end

  test "should destroy favourite" do
    assert_difference('Favourite.count', -1) do
      delete :destroy, id: @favourite
    end

    assert_redirected_to favourites_path
  end
end
