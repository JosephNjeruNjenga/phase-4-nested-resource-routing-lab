class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  def index
    if params[:user_id]
      user = User.find_by!(id: params[:user_id])
      items = user.items
      render json: items
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    item = Item.find_by!(id: params[:id])
    render json: item
  end

  def create
    item = Item.create!(item_params)
    render json: item, status: :created
  end

  private

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found_response
    render json: { errors: "Item not Found" }, status: :not_found
  end
end
