class AppController < ApplicationController
  def show
    @lists = current_user.lists.order(created_at: :desc)
  end
end
