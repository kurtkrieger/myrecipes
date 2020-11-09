require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create(chefname: "testchef", email: "testchef@example.com",
                password: "password", password_confirmation: "password")
    @recipe1 = @chef.recipes.create!(name: "vegetable sautee", description: "great vegetable recipe")
    @recipe2 = @chef.recipes.create!(name: "meat tubers", description: "great meat recipe")
  end

  
  test "should get chef show" do
    get chef_path(@chef)
    assert_template 'chefs/show'
    
    assert_match @chef.chefname.downcase, response.body.downcase
    assert_match @chef.email.downcase, response.body.downcase
    assert_select "a[href=?]", recipe_path(@recipe1), text: @recipe1.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
    assert_match @recipe1.description.downcase, response.body.downcase
    assert_match @recipe2.description.downcase, response.body.downcase
  end
  
end
