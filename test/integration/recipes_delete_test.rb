require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create(chefname: "testchef", email: "testchef@example.com",
                  password: "password", password_confirmation: "password")
    @recipe = @chef.recipes.create!(name: "vegetable sautee", description: "great vegetable recipe")
  end

  test "valid recipe delete" do
    get recipe_path(@recipe)
    assert_template "recipes/show"
    assert_difference "Recipe.count", -1 do
      delete recipe_path(@recipe)
    end
    assert_redirected_to recipes_path
    assert_not flash.empty?
  end
  
end
