class ItemsController < ApplicationController
  before_action :set_list
  before_action :set_item, only: [ :edit, :update, :destroy ]

  def new
    @item = @list.items.build
  end

  def create
    @item = @list.items.build(item_params)
    if @item.save
      redirect_to @list, notice: "Item criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to @list, notice: "Item atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to @list, notice: "Item removido com sucesso."
  end

  private

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def set_item
    @item = @list.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:title, :description, :status, :due_at)
  end
end
