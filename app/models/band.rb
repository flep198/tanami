class Band < ApplicationRecord

	has_many :datasets
	has_many :sources, :through => :datasets
	has_many :sessions, :through => :datasets

end
