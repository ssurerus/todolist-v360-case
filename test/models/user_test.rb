require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valido com email e senha" do
    user = User.new(email: "a@example.com", password: "password123")
    assert user.valid?
  end

  test "exige email" do
    user = User.new(email: nil, password: "password123")
    assert_not user.valid?
  end

  test "email deve ser unico" do
    User.create!(email: "dup@example.com", password: "password123")
    dup = User.new(email: "dup@example.com", password: "password123")
    assert_not dup.valid?
  end

  test "remove as listas ao ser destruido (dependent: :destroy)" do
    user = User.create!(email: "b@example.com", password: "password123")
    user.lists.create!(title: "Lista")
    assert_difference -> { List.count }, -1 do
      user.destroy
    end
  end
end
