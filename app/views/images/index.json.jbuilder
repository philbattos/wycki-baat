json.array!(@images) do |image|
  json.extract! image, :id, :name, :destination
  json.url image_url(image, format: :json)
end
