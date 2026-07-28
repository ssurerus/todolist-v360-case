require "test_helper"

# Testa o fluxo do dono no ListsController: caminhos felizes de CRUD e
# as falhas de validacao (422). O lado da negacao (isolamento entre
# usuarios) fica no lists_ownership_test.
class ListsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "dono@example.com", password: "password123")
    sign_in @user
    @list = @user.lists.create!(title: "Minha lista")
  end

  test "index responde com sucesso" do
    get lists_path
    assert_response :success
  end

  test "new renderiza o formulario" do
    get new_list_path
    assert_response :success
  end

  test "create com dados validos cria a lista e redireciona" do
    assert_difference -> { @user.lists.count }, 1 do
      post lists_path, params: { list: { title: "Nova lista" } }
    end
    assert_response :redirect
    assert @user.lists.exists?(title: "Nova lista")
  end

  test "create com titulo em branco nao cria e retorna 422" do
    assert_no_difference -> { List.count } do
      post lists_path, params: { list: { title: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "edit renderiza o formulario" do
    get edit_list_path(@list)
    assert_response :success
  end

  test "update com dados validos atualiza e redireciona" do
    patch list_path(@list), params: { list: { title: "Renomeada" } }
    assert_response :redirect
    assert_equal "Renomeada", @list.reload.title
  end

  test "update com titulo em branco retorna 422 e nao altera" do
    patch list_path(@list), params: { list: { title: "" } }
    assert_response :unprocessable_entity
    assert_equal "Minha lista", @list.reload.title
  end

  test "destroy remove a lista e redireciona" do
    assert_difference -> { List.count }, -1 do
      delete list_path(@list)
    end
    assert_response :redirect
  end
end
