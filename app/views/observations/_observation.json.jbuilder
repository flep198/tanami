json.extract! observation, :id, :session_id, :source_id, :band_id, :created_at, :updated_at
json.url observation_url(observation, format: :json)
