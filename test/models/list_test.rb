require "test_helper"

class ListTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: "owner@example.com", password: "password123")
  end

  test "valida com titulo e dono" do
    list = @user.lists.new(title: "Trabalho")
    assert list.valid?
  end

  test "exige titulo" do
    list = @user.lists.new(title: nil)
    assert_not list.valid?
    assert_includes list.errors[:title], "can't be blank"
  end

  test "exige um dono (user obrigatorio)" do
    list = List.new(title: "Sem dono")
    assert_not list.valid?
    assert_includes list.errors[:user], "must exist"
  end

  test "remove os itens ao ser destruida (dependent: :destroy)" do
    list = @user.lists.create!(title: "Com itens")
    list.items.create!(title: "Item 1")
    list.items.create!(title: "Item 2")
    assert_difference -> { Item.count }, -2 do
      list.destroy
    end
  end

  test "status default active e transita para archived" do
    list = @user.lists.create!(title: "Ciclo")
    assert list.active?
    list.archived!
    assert list.archived?
  end
end
