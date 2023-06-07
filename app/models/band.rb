class Band < ApplicationRecord

	has_many :datasets
	has_many :observations
	has_many :sources, :through => :observations
	has_many :sessions, :through => :observations

end
