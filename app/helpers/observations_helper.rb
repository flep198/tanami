module ObservationsHelper


	def count_public_datasets observation
		count=0
		observation.datasets.each do |dataset|
			if dataset.public
				count=count+1
			end
		end
		return count
	end

end
