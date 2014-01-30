json.array!(@forums) do |forum|
  json.extract! forum, :id, :group_id, :name, :slug, :description, :position
  json.url forum_url(forum, format: :json)
end
