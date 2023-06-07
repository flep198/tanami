class Dataset < ApplicationRecord

	belongs_to :source
	belongs_to :session
	belongs_to :band
	belongs_to :observation
	belongs_to :user, optional: true

	has_one_attached :image
	has_one_attached :uvf
	has_one_attached :fits

end
