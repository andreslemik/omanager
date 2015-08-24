json.array! @products do |p|
  json.extract! p, :id, :name
end