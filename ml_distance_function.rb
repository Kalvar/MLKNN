class MLDistanceFunction

  # Membership rate is the greater the closer
  def cosine_similarity(x1, x2)
    sumA  = 0.0
    sumB  = 0.0
    sumAB = 0.0
    x1.each.with_index{ |aValue, i| 
    	bValue  = x2[i]
    	sumA   += (aValue * aValue)
    	sumB   += (bValue * bValue)
    	sumAB  += (aValue * bValue)
    }
    (sumA * sumB > 0.0) ? sumAB / Math.sqrt(sumA * sumB) : 0.0
  end

  # Distance concept is the smaller the closer
  def eculidean(x1, x2)
  	sum = 0.0
  	x1.each.with_index{ |aValue, i| 
  		bValue  = x2[i]
  		sum    += (aValue - bValue) ** 2
  	}
  	# If sum is zero that won't be a problem in Ruby Math lib.
  	Math.sqrt(sum)
  end

  def rbf(x1, x2, sigma = 2.0)
  	sum = 0.0
  	x1.each.with_index{ |aValue, i| 
  		bValue 	= x2[i]
  		sum    += (aValue - bValue) ** 2 
  	}
    Math.exp((-sum) / (2.0 * sigma * sigma))
  end

end
