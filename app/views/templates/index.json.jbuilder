json.array!(@templates) do |template|
  json.extract! template, :id, :name, :destination
  json.url template_url(template, format: :json)
end
