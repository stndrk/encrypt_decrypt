require 'test_helper'

class CypeControllerTest < ActionDispatch::IntegrationTest
  test "should get encrypt" do
    get cype_encrypt_url
    assert_response :success
  end

  test "should get decrypt" do
    get cype_decrypt_url
    assert_response :success
  end

end
