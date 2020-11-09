require 'test_helper'

class ChefsSignupTest < ActionDispatch::IntegrationTest
  
  def setup
      @chef = Chef.new(chefname: "chef3", email: "chef3@example.com", 
                                password: "password", password_confirmation: "password")
  end
  
  test "should get signup path" do
    get signup_path
    assert_response :success
  end
  
  test "reject invalid signup" do
    get signup_path
    assert_template "chefs/new"
    
    assert_no_difference "Chef.count" do
      post chefs_path, params: { chef: {chefname: " ", email: " ", password: " ", password_confirmation: " "}}
    end
    assert_template "chefs/new"
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end
  
  test "accept valid signup" do
    get signup_path
    assert_template "chefs/new"
    
    assert_difference "Chef.count", 1 do
      post chefs_path, params: { chef: {chefname: @chef.chefname, email: @chef.email, 
                                password: @chef.password, password_confirmation: @chef.password_confirmation}}
    end
    follow_redirect!
    assert_template "chefs/show"
    assert_not flash.empty?
    assert_match @chef.chefname.downcase, response.body.downcase
    assert_match @chef.email.downcase, response.body.downcase
  end
  
end
