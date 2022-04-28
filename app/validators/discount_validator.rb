class DiscountValidator < ActiveModel::Validator 

	def validate(record)
		if  !applicable?(record)
			record.errors.add :base, 'This bulk discount cannot be created as it is not applicable with existing discounts'
		end
	end



private 

	def applicable?(record)
		relevant_discount = Hash.new
		relevant_discount[:discount] = []

		if BulkDiscount.pluck(:quantity) != [] 
	  		if BulkDiscount.pluck(:quantity).min > record.quantity 
	  			applied = true 
	  		elsif BulkDiscount.pluck(:discount).max < record.discount 
	  			applied = true 
	  		else 
	  			record.merchant.bulk_discounts.each do |discount|
	  			  if discount.quantity <= record.quantity
	  				relevant_discount[:discount] << discount.discount
	  			  end
	  			end 
	  			if relevant_discount[:discount] == []
	  				applied = true
	  			elsif relevant_discount.values.flatten.max >= record.discount 
	  				applied = false
	  			elsif relevant_discount.values.flatten.max <record.discount
	  				applied = true 
	  			end 
	  		end 
	  	else 
	  		applied = true 
	  	end
  		duplicate = BulkDiscount.pluck(:quantity).include?(record.quantity) && BulkDiscount.pluck(:discount).include?(record.discount)
  		applied && !duplicate
  	end

end