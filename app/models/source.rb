class Source < ApplicationRecord
	has_many :datasets
	has_many :observations
	has_many :sessions, :through => :observations
	has_many :bands, :through => :observations
	
	
end
