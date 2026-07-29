class AppController < ApplicationController
  def show
    @status = params[:status] == "archived" ? "archived" : "active"
    session[:lists_view] = @status
    @lists = current_user.lists.where(status: @status).order(created_at: :desc)
  end
end
