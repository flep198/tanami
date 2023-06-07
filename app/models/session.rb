class Session < ApplicationRecord

	has_many :datasets
	has_many :observations
	has_many :source, :through => :observations
	has_many :bands, :through => :observations

end
