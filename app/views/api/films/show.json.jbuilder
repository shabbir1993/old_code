json.id @film.id
json.serial @film.serial
json.dimensions @film.dimensions, :id, :width, :length

json.dimensions @film.dimensions do |dimension|
  json.id dimension.id
  json.width dimension.width.to_f
  json.length dimension.length.to_f
end

json.shelf @film.shelf
json.sales_order_code @film.sales_order_code
json.order_fill_count @film.order_fill_count
json.note @film.note
json.phase @film.phase
