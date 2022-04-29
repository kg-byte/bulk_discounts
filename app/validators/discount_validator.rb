class DiscountValidator < ActiveModel::Validator 
  def validate(record)
	if  !applicable?(record)
	  record.errors.add :base, 'This bulk discount cannot be created as it is not applicable with existing discounts'
	end
  end



private 
  def only_discount?(record)
  	BulkDiscount.pluck(:quantity) == [] 
  end

  def applicable_by_default?(record)
	if BulkDiscount.pluck(:quantity).min > record.quantity ||  BulkDiscount.pluck(:discount).max < record.discount 
	  true
	end
  end

  def relevant_discount(record)
	relevant_discount = record.merchant.bulk_discounts.map { |discount| discount.discount  if discount.quantity <= record.quantity}
  end 

  def permitted_by_relevant_discounts?(record)
	if relevant_discount(record) == [] ||  relevant_discount(record).max < record.discount
	  true
	else 
	  false
	end
  end

  def applied?(record)
	if only_discount?(record) || applicable_by_default?(record) || permitted_by_relevant_discounts?(record)
	  true 
	else 
	  false
	end
  end

  def duplicate?(record)
	BulkDiscount.pluck(:quantity).include?(record.quantity) && BulkDiscount.pluck(:discount).include?(record.discount)
  end

  def applicable?(record)
	applied?(record) && !duplicate?(record)
  end
end