require "test_helper"

class SupportControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  test "should get new" do
    get support_url
    assert_response :success
  end

  test "should create support message" do
    assert_difference "SupportMessage.count", 1 do
      post support_url, params: { name: "Test User", email: "test@example.com", message: "Help me!" }
    end
    assert_redirected_to root_url
    assert_equal I18n.t("support.notices.success"), flash[:notice]
  end

  test "should not create support message with missing fields" do
    assert_no_difference "SupportMessage.count" do
      post support_url, params: { name: "", email: "", message: "" }
    end
    assert_response :unprocessable_entity
    assert_match I18n.t("support.notices.error"), response.body
  end
end
