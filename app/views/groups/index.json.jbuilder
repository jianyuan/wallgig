json.array!(@groups) do |group|
  json.extract! group, :id, :owner_id, :name, :slug, :description, :public, :admin_title, :moderator_title, :member_title, :has_forums
  json.url group_url(group, format: :json)
end
