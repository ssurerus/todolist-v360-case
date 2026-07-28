require "test_helper"

# Verifica o rate limiting no login (anti brute-force).
# O ambiente de teste usa :memory_store, entao o contador do rate_limit
# realmente acumula. Limpamos o cache no setup/teardown para nao vazar
# contadores entre execucoes.
class LoginRateLimitTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear
    @user = User.create!(email: "vitima@example.com", password: "password123")
  end

  teardown do
    Rails.cache.clear
  end

  test "bloqueia apos exceder o limite de tentativas de login" do
    # Limite: 10 tentativas / 3 min. As 10 primeiras passam para o Devise
    # (falham por senha errada), a 11a e barrada pelo rate_limit.
    10.times do
      post user_session_path, params: { user: { email: @user.email, password: "senha-errada" } }
    end

    post user_session_path, params: { user: { email: @user.email, password: "senha-errada" } }

    assert_redirected_to new_user_session_path
    assert_equal "Muitas tentativas de login. Aguarde alguns instantes e tente novamente.", flash[:alert]
  end
end
