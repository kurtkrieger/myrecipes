require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "testchef", email: "testchef@example.com",
                  password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "testchef2", email: "testchef2@example.com",
                  password: "password", password_confirmation: "password")
    @admin = Chef.create!(chefname: "admin", email: "admin@example.com",
                  password: "password", password_confirmation: "password", admin: true)
    # @recipe = @chef.recipes.create!(name: "vegetable sautee", description: "great vegetable recipe")
  end
  
  test "reject invalid edit chef" do
    sign_in_as(@chef, "password")
    
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    
    patch chef_path(@chef), params: { chef: {chefname: " ", email: " ", password: " ", password_confirmation: " "}}
    
    assert_template "chefs/edit"
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end
  
  test "accept valid edit chef" do
    sign_in_as(@chef, "password")
    
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
  
  test "accept valid edit chef by admin" do
    sign_in_as(@admin, "password")

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
  
  test "reject edit chef by different chef" do
    sign_in_as(@chef, "password")

    orig_chefname = @chef2.chefname
    orig_email    = @chef2.email
    new_chefname = "test2chef2"
    new_email    = "test2chef2@blahblah.net"
    
    patch chef_path(@chef2), params: { chef: {chefname: new_chefname, email: new_email}}
    
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef2.reload
    assert_match orig_chefname, @chef2.chefname
    assert_match orig_email, @chef2.email
  end
  
end
