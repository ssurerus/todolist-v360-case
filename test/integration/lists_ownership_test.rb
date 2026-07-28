require "test_helper"

# Garante o isolamento de dados por usuario (protecao contra IDOR / OWASP A01).
# Todo acesso a listas e itens e escopado por current_user, entao um usuario
# jamais deve ver, editar ou excluir recursos de outro - mesmo sabendo o UUID.
class ListsOwnershipTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = User.create!(email: "alice@example.com", password: "password123")
    @bob   = User.create!(email: "bob@example.com", password: "password123")
    @alice_list = @alice.lists.create!(title: "Lista da Alice")
    @alice_item = @alice_list.items.create!(title: "Item da Alice")
  end

  test "usuario nao autenticado e redirecionado para o login" do
    get list_path(@alice_list)
    assert_redirected_to new_user_session_path
  end

  test "o dono acessa a propria lista" do
    sign_in @alice
    get list_path(@alice_list)
    assert_response :success
  end

  test "usuario NAO pode ver a lista de outro (IDOR)" do
    sign_in @bob
    get list_path(@alice_list)
    assert_response :not_found
  end

  test "usuario NAO pode editar a lista de outro" do
    sign_in @bob
    patch list_path(@alice_list), params: { list: { title: "Invadido" } }
    assert_response :not_found
    assert_equal "Lista da Alice", @alice_list.reload.title
  end

  test "usuario NAO pode excluir a lista de outro" do
    sign_in @bob
    assert_no_difference -> { List.count } do
      delete list_path(@alice_list)
    end
    assert_response :not_found
  end

  test "usuario NAO pode criar item na lista de outro" do
    sign_in @bob
    assert_no_difference -> { Item.count } do
      post list_items_path(@alice_list), params: { item: { title: "Intruso" } }
    end
    assert_response :not_found
  end

  test "usuario NAO pode excluir item da lista de outro" do
    sign_in @bob
    assert_no_difference -> { Item.count } do
      delete list_item_path(@alice_list, @alice_item)
    end
    assert_response :not_found
  end
end
