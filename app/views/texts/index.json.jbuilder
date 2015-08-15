json.array!(@texts) do |text|
  json.extract! text, :id, :name, :destination
  json.url text_url(text, format: :json)
end
