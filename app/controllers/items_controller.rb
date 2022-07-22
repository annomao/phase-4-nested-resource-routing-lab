class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    if params[:user_id]
      user = find_user
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
    user = find_user
    item = user.items.create(allowed_params)
    render json: item, status: :created
  end

  private

  def find_user
    User.find(params[:user_id])
  end

  def not_found_response
    render json: {error: "record not found"}, status: :not_found
  end

  def allowed_params
    params.permit(:name, :description, :price)
  end

end
