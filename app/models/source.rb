class Source < ApplicationRecord
	has_many :datasets
	has_many :sessions, :through => :datasets
	has_many :bands, :through => :datasets
	
end
