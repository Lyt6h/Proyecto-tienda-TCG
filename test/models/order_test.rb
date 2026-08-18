require "test_helper"

class OrderTest < ActiveSupport::TestCase
  def setup
    @order = orders(:one)
  end

  test "should be valid" do
    assert @order.valid?
  end

  test "status should be in allowed values" do
    @order.status = "invalid"
    assert_not @order.valid?

    %w[pending_approval accepted delivered rejected completed].each do |status|
      @order.status = status
      assert @order.valid?, "#{status} should be valid"
    end
  end

  test "subtotal should be present and non-negative" do
    @order.subtotal = nil
    assert_not @order.valid?
    @order.subtotal = -1
    assert_not @order.valid?
  end

  test "service_fee should be present and non-negative" do
    @order.service_fee = nil
    assert_not @order.valid?
    @order.service_fee = -1
    assert_not @order.valid?
  end

  test "total_price should be present and non-negative" do
    @order.total_price = nil
    assert_not @order.valid?
    @order.total_price = -1
    assert_not @order.valid?
  end
end
