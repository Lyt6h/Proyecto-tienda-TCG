require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "new" do
    get new_password_path
    assert_response :success
  end

  test "create" do
    assert_emails 1 do
      post passwords_path, params: { email_address: @user.email_address }
    end
    assert_redirected_to new_session_path

    follow_redirect!
    assert_notice "instructions_sent"
  end

  test "create for an unknown user redirects but sends no mail" do
    post passwords_path, params: { email_address: "missing-user@example.com" }
    assert_enqueued_emails 0
    assert_redirected_to new_session_path

    follow_redirect!
    assert_notice "instructions_sent"
  end

  test "edit" do
    token = @user.generate_token_for(:password_reset)
    get edit_password_path(token: token)
    assert_response :success
  end

  test "edit with invalid password reset token" do
    get edit_password_path(token: "invalid token")
    assert_redirected_to new_password_path

    follow_redirect!
    assert_notice "invalid_or_expired"
  end

  test "update" do
    token = @user.generate_token_for(:password_reset)
    assert_changes -> { @user.reload.password_digest } do
      put password_path(token: token), params: { password: "newpassword", password_confirmation: "newpassword" }
      assert_redirected_to new_session_path
    end

    follow_redirect!
    assert_notice "reset_success"
  end

  test "update with non matching passwords" do
    token = @user.generate_token_for(:password_reset)
    assert_no_changes -> { @user.reload.password_digest } do
      put password_path(token: token), params: { password: "newpassword", password_confirmation: "mismatch" }
      assert_redirected_to edit_password_path(token: token)
    end
  end

  private
    def assert_notice(key)
      # Buscamos la traducción para el mensaje flash
      text = I18n.t("flash.passwords.#{key}")
      unless response.body.include?(text)
        puts "DEBUG: Expected text '#{text}' not found in response body."
        puts "DEBUG: Response body: #{response.body}"
      end
      assert_select "div", /#{Regexp.escape(text)}/i
    end
end
