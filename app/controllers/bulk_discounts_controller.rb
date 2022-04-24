class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    merchant.bulk_discounts.create(discount_params)
    redirect_to merchant_bulk_discounts_path(merchant.id)
  end

  def edit 
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    if bulk_discount.updatable?
      bulk_discount.update(discount_params)
      redirect_to merchant_bulk_discount_path(merchant.id, bulk_discount.id)
    else 
      flash[:notice] = "Unable to update this Bulk Discount due to Pending Invoices!"
      redirect_to merchant_bulk_discount_path(merchant.id, bulk_discount.id)
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    if bulk_discount.updatable?
      bulk_discount.destroy
      redirect_to merchant_bulk_discounts_path(merchant.id)
    else 
      flash[:notice] = "Unable to delete this Bulk Discount due to Pending Invoices!"
      redirect_to merchant_bulk_discounts_path(merchant.id)
    end
  end

private 
  def discount_params
    params.permit(:quantity, :discount)
  end

end