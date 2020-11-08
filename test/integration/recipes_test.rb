require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "testchef", email: "testchef@example.com")
    @recipe1 = @chef.recipes.create!(name: "vegetable sautee", description: "great vegetable recipe")
    @recipe2 = @chef.recipes.create!(name: "meat tubers", description: "great meat recipe")
  end
  
  test "should get recipes index" do
    get recipes_path
    assert_response :success
  end
  
  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_select "a[href=?]", recipe_path(@recipe1), text: @recipe1.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end
  
  test "should get recipe show" do
    get recipe_path(@recipe1)
    assert_template 'recipes/show'
    assert_match @recipe1.name.downcase , response.body.downcase
    assert_match @recipe1.description, response.body
    assert_match @chef.chefname, response.body
    assert_select "a[href=?]", edit_recipe_path(@recipe1), text: "Edit this recipe"
    assert_select "a[href=?]", recipe_path(@recipe1), text: "Delete this recipe"
  end
  
  test "valid recipe create" do
    get new_recipe_path
    assert_template "recipes/new"
    
    r_name = "Vegetable Sautee"
    r_desc = "Add chicken to broth"
    
    assert_difference "Recipe.count", 1 do
      post recipes_path, params: { recipe: {name: r_name, description: r_desc}}
    end
    follow_redirect!
    assert_template "recipes/show"
    assert_match r_name.downcase, response.body.downcase
    assert_match r_desc.downcase, response.body.downcase
  end
  
  test "reject recipe create" do
    get new_recipe_path
    assert_template "recipes/new"
    
    assert_no_difference "Recipe.count" do
      post recipes_path, params: { recipe: {name: " ", description: " "}}
    end
    assert_template "recipes/new"
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end
  

end
