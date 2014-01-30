json.array! @collections do |collection|
  json.extract! collection, :id, :name, :public, :collect_status
end
