require "test_helper"

# Testa o fluxo do dono no ItemsController: criar, avancar status, editar
# e remover itens dentro de uma lista propria, mais a falha de validacao.
class ItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "dono@example.com", password: "password123")
    sign_in @user
    @list = @user.lists.create!(title: "Lista")
    @item = @list.items.create!(title: "Tarefa")
  end

  test "create com dados validos adiciona item na lista" do
    assert_difference -> { @list.items.count }, 1 do
      post list_items_path(@list), params: { item: { title: "Nova tarefa" } }
    end
    assert_response :redirect
  end

  test "create sem titulo retorna 422 e nao cria" do
    assert_no_difference -> { Item.count } do
      post list_items_path(@list), params: { item: { title: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "update avanca o status do item" do
    patch list_item_path(@list, @item), params: { item: { status: "in_progress" } }
    assert_response :redirect
    assert @item.reload.in_progress?
  end

  test "destroy remove o item" do
    assert_difference -> { @list.items.count }, -1 do
      delete list_item_path(@list, @item)
    end
    assert_response :redirect
  end
end
