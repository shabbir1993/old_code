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

  def utilization_label(width, length)
    search_width = params[:min_width].to_f
    search_length = params[:min_length].to_f
    if width && length && params[:min_width] && params[:min_length] && width >= search_width && length >= search_length
      content_tag(:span, class: "label label-warning") do
        number_to_percentage(100*(search_width*search_length)/(width*length), precision: 2)
      end
    end
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
