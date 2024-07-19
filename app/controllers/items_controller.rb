class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # finds
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item
  end

  def create
    user = User.find(params[:user_id])
    item = user.items.create(item_params)
    if item.valid?
      render json: item, status: :created
    else
      render json: { errors: "Item not created" }, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found
    render json: { errors: "Item not found" }, status: :not_found
  end

end
