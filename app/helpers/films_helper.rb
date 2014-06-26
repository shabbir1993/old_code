module FilmsHelper

  def utilization_label(width, length)
    if params[:width_greater_than].present? && params[:length_greater_than].present? && width >= search_width && length >= search_length
      content_tag(:span, class: "label label-warning") do
        number_to_percentage(100*(search_width*search_length)/(width*length), precision: 2)
      end
    end
  end

  def sales_order_assign_choices(film)
    in_progress_orders = current_tenant.sales_orders.in_progress
    film.sales_order.present? ? in_progress_orders.to_set << film.sales_order : in_progress_orders
  end

  def destination_choices(films)
    films.map{ |f| f.valid_destinations }.uniq.reduce(:&)
  end

  def search_width
    @search_width ||= params[:width_greater_than].to_f unless params[:width_greater_than].empty?
  end

  def search_length
    @search_length ||= params[:length_greater_than].to_f unless params[:length_greater_than].empty?
  end

  def moved_to(film)
    if film.deleted?
      "deleted"
    else
      film.phase
    end
  end
end
