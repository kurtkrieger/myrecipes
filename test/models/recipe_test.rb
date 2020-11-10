require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  def setup
    @chef = Chef.create!(chefname: "testchef", email: "testchef@example.com",
                  password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "vegetable", description: "great vegetable recipe", chef: @chef)
  end
  
  test "recipe should be valid" do
    assert @recipe.valid?
  end  
  
  test "name should be present" do
    @recipe.name = " "
    assert_not @recipe.valid?
  end
  
  test "name shouldn't be less than 5 characters" do
    @recipe.name = "a" * 4
    assert_not @recipe.valid?
  end
  
  test "name shouldn't be more than 100 characters" do
    @recipe.name = "a" * 101
    assert_not @recipe.valid?
  end

  test "description should be present" do
    @recipe.description = " "
    assert_not @recipe.valid?
  end
  
  test "description shouldn't be less than 10 characters" do
    @recipe.description = "a" * 9
    assert_not @recipe.valid?
  end
  
  test "description shouldn't be more than 2000 characters" do
    @recipe.description = "a" * 2001
    assert_not @recipe.valid?
  end
end