class MerchantItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    if !params[:item].nil?
      item = Item.find(params[:item])
      item.update(status: params[:status])
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      item = Item.find(params[:item_id])
      item.update(item_params)
      redirect_to "/merchants/#{@merchant.id}/items/#{item.id}", notice: "Item Successfully Updated"
    end
  end

  def show
    @item = Item.find(params[:item_id])
  end

  def edit
    @item = Item.find(params[:item_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.create(item_params)
    if  item.save
      redirect_to "/merchants/#{merchant.id}/items"
    else 
      flash[:notice] = "All required fields must be filled!"
      redirect_to "/merchants/#{merchant.id}/items/new"
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
