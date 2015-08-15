json.array!(@folios) do |folio|
  json.extract! folio, :id, :name, :destination
  json.url folio_url(folio, format: :json)
end
