require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create(chefname: "testchef", email: "testchef@example.com",
                  password: "password", password_confirmation: "password")
    @recipe = @chef.recipes.create!(name: "vegetable sautee", description: "great vegetable recipe")
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
  
  # test "valid edit chef" do
  #   get edit_recipe_path(@recipe)
  #   assert_template "recipes/edit"
  #   r_name = "updated recipe name"
  #   r_desc = "updated recipe description"
  #   patch recipe_path(@recipe), params: { recipe: {name: r_name, description: r_desc}}
  #   assert_not flash.empty?
  #   @recipe.reload
  #   assert_match r_name, @recipe.name
  #   assert_match r_desc, @recipe.description
  # end
  
end
