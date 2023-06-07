class Observation < ApplicationRecord

	belongs_to :source
	belongs_to :session
	belongs_to :band

	has_many :datasets
	has_one_attached :calibrated_uvf

end
