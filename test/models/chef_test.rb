require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  
  def setup
    @chef = Chef.new(chefname: "testchef", email: "testchef@example.com")
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
  
end