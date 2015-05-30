json.array!(@campaigns) do |campaign|
  json.extract! campaign, :id, :title, :description, :other_links, :owner, :category, :raised_amount, :total_amount
  json.url campaign_url(campaign, format: :json)
end
