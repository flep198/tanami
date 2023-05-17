class Dataset < ApplicationRecord

	belongs_to :source
	belongs_to :session
	belongs_to :band

	has_one_attached :image
	has_one_attached :uvf

end
