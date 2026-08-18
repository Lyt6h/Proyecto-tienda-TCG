require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "usuario invalido sin email" do
    user = User.new(username: "user", password: "abc")
    result = user.save
    assert_not result, "usuario no deveria ser valido sin email"
  end

  test "usuario invalido con password menor a 6 caracteres" do
    user = User.new(username: "user", email_address: "user@test.com", password: "abc")
    result = user.save
    assert_not result, "usuario no deveria ser valido con largo de password menor a 6"
  end

  test "usuario invalido con caracteres especiales en username" do
    user = User.new(username: "user!!", email_address: "user@test.com", password: "password123")
    result = user.save
    assert_not result, "usuario no deveria ser valido con caracteres especiales en el nombre"
  end
end
