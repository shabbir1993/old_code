json.id @split.id
json.serial @split.serial
json.dimensions @split.dimensions, :id, :width, :length

json.dimensions @split.dimensions do |dimension|
  json.id dimension.id
  json.width dimension.width.to_f
  json.length dimension.length.to_f
end

json.shelf @split.shelf
if @split.sales_order
  json.sales_order @split.sales_order, :id, :code
end

json.order_fill_count @split.order_fill_count
json.note @split.note
json.phase @split.phase
json.allowed_destinations @split.valid_destinations
