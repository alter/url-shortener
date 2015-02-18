require 'test_helper'

class UrlControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should show full_url" do
    get(:show, {'id' => urls(:mail).short_url})
    assert_response :redirect
    assert_redirected_to urls(:mail).full_url
  end

end
