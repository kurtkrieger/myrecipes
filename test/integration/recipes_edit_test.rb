require 'test_helper'

class RecipesEditTestTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.new(chefname: "testchef", email: "testchef@example.com",
                  password: "password", password_confirmation: "password")
    @recipe = @chef.recipes.create!(name: "vegetable sautee", description: "great vegetable recipe")
  end
  
  test "reject invalid edit recipe" do
    get edit_recipe_path(@recipe)
    assert_template "recipes/edit"
    patch recipe_path(@recipe), params: { recipe: {name: " ", description: " "}}
    assert_template "recipes/edit"
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end
  
  test "valid edit recipe" do
    get edit_recipe_path(@recipe)
    assert_template "recipes/edit"
    r_name = "updated recipe name"
    r_desc = "updated recipe description"
    patch recipe_path(@recipe), params: { recipe: {name: r_name, description: r_desc}}
    assert_not flash.empty?
    @recipe.reload
    assert_match r_name, @recipe.name
    assert_match r_desc, @recipe.description
  end
  
end
