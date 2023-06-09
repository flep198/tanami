module SourcesHelper



def get_source_selection sources, user_signed_in

	if user_signed_in 
		return sources
	else 
		output_source_ids=[]
		Dataset.all.each do |dataset|
			if (dataset.public) and not output_source_ids.include?(dataset.source.id)
				output_source_ids.push(dataset.source.id)
			end
		end
		return sources.where(:id => output_source_ids)
	end

end

end
