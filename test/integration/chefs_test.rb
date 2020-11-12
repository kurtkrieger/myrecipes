require 'test_helper'

class ChefsTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "testchef", email: "testchef@example.com",
                  password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "testchef2", email: "testchef2@example.com",
                  password: "password", password_confirmation: "password")
    @admin = Chef.create!(chefname: "admin", email: "admin@example.com",
                  password: "password", password_confirmation: "password",
                  admin: true)
  end
  
  test "should get chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef), text: @chef.chefname
  end
  
  test "should delete chef if admnin" do
    sign_in_as(@admin, "password")
    get chefs_path
    assert_template "chefs/index"
    assert_difference "Chef.count", -1 do
      delete chef_path(@chef2)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
  
  test "can't delete chef if not admnin" do
    sign_in_as(@chef, "password")
    get chefs_path
    assert_template "chefs/index"
    assert_no_difference "Chef.count" do
      delete chef_path(@chef2)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
  
end
