json.array! @manufacturers do |m|
  json.extract! m, :id, :name
end