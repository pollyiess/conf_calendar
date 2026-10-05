require "test_helper"

class UiKitControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ui_kit_index_url
    assert_response :success
  end
end
