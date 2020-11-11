require 'test_helper'

class ChefsLoginTest < ActionDispatch::IntegrationTest
  
  test "Invalid login credentials" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: " ", passworod: " " } }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "Valid login credentials" do
    get login_path
    assert_template "sessions/new"
    chef = Chef.create!(chefname: "testchef", email: "aaa@bbb.com", password: "password", password_confirmation: "password")
    post login_path, params: { session: { email: "aaa@bbb.com", password: "password" } }
    assert_redirected_to chef
    follow_redirect!
    assert_template "chefs/show"
    assert_not flash.empty?
    assert_match chef.chefname.downcase, response.body.downcase
    # assert_match chef.email.downcase, response.body.downcase
  end
  
end
