require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "testchef", email: "testchef@example.com",
                  password: "password", password_confirmation: "password")
    @recipe = @chef.recipes.create!(name: "vegetable sautee", description: "great vegetable recipe")
    sign_in_as(@chef, "password")
  end
  
  test "reject invalid edit chef" do
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    
    patch chef_path(@chef), params: { chef: {chefname: " ", email: " ", password: " ", password_confirmation: " "}}
    
    assert_template "chefs/edit"
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end
  
  test "valid edit chef" do
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    
    r_chefname = "test2chef"
    r_email    = "test2chef@blahblah.net"
    
    patch chef_path(@chef), params: { chef: {chefname: r_chefname, email: r_email}}
    
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match r_chefname, @chef.chefname
    assert_match r_email, @chef.email
  end
  
end
