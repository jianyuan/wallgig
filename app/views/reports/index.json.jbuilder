json.array!(@reports) do |report|
  json.extract! report, :id, :reportable_id, :reportable_type, :user_id, :description, :closed_by_id, :closed_at
  json.url report_url(report, format: :json)
end
