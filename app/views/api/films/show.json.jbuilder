json.id @film.id
json.serial @film.serial
json.dimensions @film.dimensions, :id, :width, :length
json.shelf @film.shelf
json.sales_order_code @film.sales_order_code
json.order_fill_count @film.order_fill_count
json.note @film.note
json.phase @film.phase
json.in_progress_orders current_tenant.sales_orders.in_progress, :id, :code
