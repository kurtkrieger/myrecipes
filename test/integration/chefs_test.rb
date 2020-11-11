require 'test_helper'

class ChefsTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create(chefname: "testchef", email: "testchef@example.com",
                  password: "password", password_confirmation: "password")
    @chef2 = Chef.create(chefname: "testchef2", email: "testchef2@example.com",
                  password: "password", password_confirmation: "password")
    # @recipe1 = @chef.recipes.create!(name: "vegetable sautee", description: "great vegetable recipe")
    # @recipe2 = @chef.recipes.create!(name: "meat tubers", description: "great meat recipe")
  end
  
  test "should get chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef), text: @chef.chefname
  end
  
  test "should delete chef" do
    get chefs_path
    assert_template "chefs/index"
    assert_difference "Chef.count", -1 do
      delete chef_path(@chef)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
  
end
