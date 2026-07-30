require "test_helper"

class ItemTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: "owner@example.com", password: "password123")
    @list = @user.lists.create!(title: "Lista")
  end

  test "valido com titulo e lista" do
    assert @list.items.new(title: "Estudar").valid?
  end

  test "exige titulo" do
    item = @list.items.new(title: nil)
    assert_not item.valid?
  end

  test "exige uma lista" do
    item = Item.new(title: "Solto")
    assert_not item.valid?
    assert_includes item.errors[:list], "é obrigatório(a)"
  end

  test "status enum: backlog -> in_progress -> done" do
    item = @list.items.create!(title: "Tarefa")
    assert item.backlog?
    item.in_progress!
    assert item.in_progress?
    item.done!
    assert item.done?
  end

  test "scope ordered ordena por due_at ascendente" do
    depois = @list.items.create!(title: "Depois", due_at: 2.days.from_now)
    antes  = @list.items.create!(title: "Antes", due_at: 1.day.from_now)
    assert_equal [ antes, depois ], @list.items.ordered.to_a
  end
end
