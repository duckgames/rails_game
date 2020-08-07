require 'test_helper'

class EmpiresControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get empires_new_url
    assert_response :success
  end

end
