json.extract! event, :id, :device_id, :event_datetime, :temparature, :humidity, :illumination, :movement, :created_at, :updated_at
json.url event_url(event, format: :json)
