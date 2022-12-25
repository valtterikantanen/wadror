json.extract! brewery, :id, :name, :year, :active
json.beers do
  json.amount brewery.beers.length
end
