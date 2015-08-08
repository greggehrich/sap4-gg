json.array!(@hoteljunks) do |hoteljunk|
  json.extract! hoteljunk, :id, :name
  json.url hoteljunk_url(hoteljunk, format: :json)
end
