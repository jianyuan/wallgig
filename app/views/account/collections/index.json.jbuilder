json.array!(@collections) do |collection|
  json.extract! collection, :id, :user_id, :name, :public, :ancestry, :position
  json.url collection_url(collection, format: :json)
end
