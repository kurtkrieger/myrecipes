require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  
  def setup
    @chef = Chef.new(chefname: "testchef", email: "testchef@example.com",
                  password: "password", password_confirmation: "password")
  end
  
  test "chef should be valid" do
    assert @chef.valid?
  end  
  
  test "chefname should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end
  
  test "chefname shouldn't be less than 2 characters" do
    @chef.chefname = "a"
    assert_not @chef.valid?
  end
  
  test "chefname shouldn't be more than 20 characters" do
    @chef.chefname = "a" * 21
    assert_not @chef.valid?
  end
  
  test "email should be properly formatted" do
    @chef.email = "xxx"
    assert_not @chef.valid?
    @chef.email = "a@b.com"
    assert @chef.valid?
  end
  
  test "email should be lowercase" do
    temp_email = "AAA@b.com"
    @chef.email = temp_email
    @chef.save
    assert_equal temp_email.downcase, @chef.reload.email
  end
  
  test "password should be present" do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end
  
  test "password shouldn't be less than 5 chars" do
    @chef.password = @chef.password_confirmation = "a"
    assert_not @chef.valid?
  end
  
  test "password shouldn't be more than 20 characters" do
    @chef.password = "a" * 21
    assert_not @chef.valid?
  end
  
end