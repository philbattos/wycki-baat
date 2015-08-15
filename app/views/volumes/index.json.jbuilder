json.array!(@volumes) do |volume|
  json.extract! volume, :id, :name, :destination
  json.url volume_url(volume, format: :json)
end
