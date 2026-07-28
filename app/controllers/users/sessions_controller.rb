module Users
  class SessionsController < Devise::SessionsController
    rate_limit to: 10, within: 3.minutes, only: :create,
               by: -> { request.remote_ip },
               with: -> { redirect_to new_user_session_path, alert: "Muitas tentativas de login. Aguarde alguns instantes e tente novamente." }
  end
end
