class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  def index
    @lists = List.all
  end

  def new
    @list = List.new

    8.times do
      @list.items.new
    end
  end

  def create
    @list  = List.new(list_params)
    if @list.save
      UserList.create(user_id: session[:user_id],list_id: @list.id)
      redirect_to @list
    else
      flash[:errors] = @list.errors.full_messages
      redirect_to new_list_path
    end
  end

  def show
  end

  def edit
    4.times do
      @list.items.new
    end
  end

  def update
    ListItem.where(list_id: @list.id).destroy_all
    @list.update(list_params)
    redirect_to @list
  end

  def destroy
    @list.list_items.each do |list_item|
      list_item.destroy
    end
    @list.user_lists.each do |user_list|
      user_list.destroy
    end
    @list.destroy
    redirect_to lists_path
  end

  private

  def list_params
    params.require(:list).permit(:name, item_ids:[], items_attributes: [:name], list_items_attributes: [:item_quantity])
  end

  def set_list
    @list = List.find(params[:id])
  end
end
