json.array!(@forum_topics) do |forum_topic|
  json.extract! forum_topic, :id, :forum_id, :user_id, :title, :content, :cooked_content, :pinned, :locked, :hidden
  json.url forum_topic_url(forum_topic, format: :json)
end
