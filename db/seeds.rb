resources = {
  water: 4,
  food: 3,
  medication: 2,
  ammunition: 1
}
resources.each do |item, value|
  Resource.create(item: item, value: value)
end
