require 'test_helper'

class ActiveAdminTest < ActionDispatch::IntegrationTest
  test "the activeadmin login" do
    visit admin_root_path
    visit new_admin_user_session_path
    fill_in "Email", with: 'superadmin@isonweb.com'
    fill_in 'Password', with: 'wrong_password'
    click_on 'Login'
    assert page.has_content?('Invalid email or password'), 'wrong email/password'
    fill_in 'Password', with: 'super_password'
    click_on 'Login'
    assert page.has_content?('Signed in successfully'), 'didnt get to the Dashboard'
  end
end
