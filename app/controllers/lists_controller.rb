class ListsController < ApplicationController
  before_action :set_list, only: [ :show, :edit, :update, :destroy, :archive, :unarchive ]

  def index
    @lists = current_user.lists.order(created_at: :desc)
  end

  def show
    @items = @list.items.ordered
    @current_list_id = @list.id
    session[:current_list_id] = @list.id
    respond_to do |format|
      format.html
      format.turbo_stream { render :show }
    end
  end

  def new
    @list = List.new
  end

  def create
    @view_status = session[:lists_view] || "active"
    @list = current_user.lists.new(list_params)
    if @list.save
      respond_to do |format|
        format.html { redirect_to @list, notice: "Lista criada com sucesso." }
        format.turbo_stream { flash.now[:notice] = "Lista criada com sucesso." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @current_list_id = session[:current_list_id]
  end

  def update
    if @list.update(list_params)
      @items = @list.items.ordered
      @current_list_id = params[:current_list_id] || session[:current_list_id]
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "Lista atualizada com sucesso." }
        format.html { redirect_to @list, notice: "Lista atualizada com sucesso." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_list_id = session[:current_list_id]
    @list.destroy
    session[:current_list_id] = nil if current_list_id == @list.id
    respond_to do |format|
      format.turbo_stream {
        flash.now[:notice] = "Lista removida com sucesso."
        render :destroy, locals: {
          lists: current_user.lists.order(created_at: :desc),
          current_list_id: current_list_id
        }
      }
      format.html { redirect_to lists_path, notice: "Lista removida com sucesso." }
    end
  end

  def archive
    @was_current = session[:current_list_id] == @list.id
    @list.archived!
    session[:current_list_id] = nil if @was_current
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Lista arquivada com sucesso." }
      format.html { redirect_to app_path, notice: "Lista arquivada com sucesso." }
    end
  end

  def unarchive
    @list.active!
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Lista desarquivada com sucesso." }
      format.html { redirect_to app_path(status: "archived"), notice: "Lista desarquivada com sucesso." }
    end
  end

 private

  def set_list
    @list = current_user.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:id, :title, :description, :status, :color)
  end
end
