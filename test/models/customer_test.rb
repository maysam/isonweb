require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test "customer is under an admin user" do
    customer = Customer.new email: 'a@b.com'
    refute customer.save, 'cannot save'
    customer = Customer.new name: 'ali reza', email: 'a@b.com', admin_user: admin_users(:normaladmin)
    assert customer.save, 'can save'
  end
end
