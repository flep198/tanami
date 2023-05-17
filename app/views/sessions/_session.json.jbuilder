json.extract! session, :id, :data, :comment, :obs_code, :created_at, :updated_at
json.url session_url(session, format: :json)
