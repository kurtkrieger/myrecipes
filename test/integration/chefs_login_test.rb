require 'test_helper'

class ChefsLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "testchef", email: "aaa@bbb.com", password: "password", password_confirmation: "password")
  end
  
  test "Invalid login credentials" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: " ", passworod: " " } }
    assert_template "sessions/new"
    assert_not flash.empty?
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    get root_path
    assert flash.empty?
  end
  
  test "Valid login credentials" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: @chef.email, password: "password" } }
    assert_redirected_to @chef
    follow_redirect!
    assert_template "chefs/show"
    assert_not flash.empty?
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_match @chef.chefname.downcase, response.body.downcase
    # assert_match @chef.email.downcase, response.body.downcase
    assert_select "a[href=?]", chef_path(@chef)
    assert_select "a[href=?]", edit_chef_path(@chef)
  end
  
end
