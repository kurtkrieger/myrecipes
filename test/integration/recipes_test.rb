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
  
  test "should get listing of recipes" do
    get recipes_path
    assert_template 'recipes/index'    
    assert_match @recipe1.name, response.body
    assert_match @recipe2.name, response.body
  end

end
