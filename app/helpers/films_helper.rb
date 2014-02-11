module FilmsHelper
  def select_box(film)
    check_box_tag "film_ids[]", film.id, false, class: "film-select" unless film.deleted?
  end

  def link_to_edit_or_restore(film)
    if film.deleted == true 
      link_to restore_film_path(film), method: :patch, remote: true, id: "film-#{film.id}-restore" do 
        content_tag(:i, nil, class: "fa fa-wrench")
      end 
    else 
      link_to edit_film_path(film), { :"data-toggle" => "modal", :"data-target" => "#forms-modal", id: "film-#{film.id}-edit" } do 
        content_tag(:i, nil, class: "fa fa-edit")
      end 
    end 
  end

  def link_to_split(film)
    link_to split_film_path(film), method: :post, remote: true, id: "film-#{film.id}-split" do 
      content_tag(:i, nil, class: "fa fa-scissors")
    end if film.phase == "stock" && !film.deleted
  end

  def dimension_cell(film, dimension)
    second_dimension = "second_#{dimension}".to_sym
    if film.try(second_dimension)
      [film.send(dimension), tag('br'), film.send(second_dimension)].join.html_safe
    else
      film.send(dimension)
    end
  end

  def utilization_label(film)
    content_tag(:span, class: "label label-warning") do
      film.utilization(params[:min_width].to_f, params[:min_length].to_f)
    end if params[:min_width].present? && params[:min_length].present?
  end

  def second_utilization_label(film)
    content_tag(:span, class: "label label-warning") do
      film.second_utilization(params[:min_width].to_f, params[:min_length].to_f)
    end if params[:min_width].present? && params[:min_length].present?
  end

  def area_cell(film)
    first_row = [film.area, utilization_label(film)].join
    if film.try(:second_area)
      second_row = [tag('br'), film.second_area, second_utilization_label(film)].join
    else
      second_row = ""
    end
    [first_row, second_row].join.html_safe
  end

  def fill_count_badge(film)
    content_tag(:span, class: "badge") do
      film.order_fill_count
    end if film.order_fill_count > 1 && film.sales_order.present?
  end

  def sales_order_assign_choices(film)
    unshipped_orders = current_tenant.widgets(SalesOrder).unshipped
    film.sales_order.present? ? unshipped_orders.to_set << film.sales_order : unshipped_orders
  end

  def destination_choices(films)
    films.map{ |f| PhaseDefinitions.destinations_for(f.phase) }.uniq.reduce(:&)
  end
end
