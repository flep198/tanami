class Session < ApplicationRecord

	has_many :datasets
	has_many :source, :through => :datasets
	has_many :bands, :through => :datasets

end
