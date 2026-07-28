class ItemsController < ApplicationController
  before_action :set_list
  before_action :set_item, only: [ :edit, :update, :destroy ]
  def new
    @item = @list.items.build
  end

  def create
    @item = @list.items.build(item_params)

    if @item.save
      @items = @list.items.ordered
      respond_to do |format|
        format.html { redirect_to list_path(@list), notice: "Item criado com sucesso." }
        format.turbo_stream { flash.now[:notice] = "Item criado com sucesso." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    @items = @list.items.ordered
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Item removido com sucesso." }
      format.html { redirect_to list_path(@list), notice: "Item removido com sucesso." }
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "Item atualizado com sucesso." }
        format.html { redirect_to list_path(@list), notice: "Item atualizado com sucesso." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def set_item
    @item = @list.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:id, :title, :description, :status, :due_at)
  end
end
