module ApplicationHelper
  def modal_form_for(object, options = {}, &block)
    options[:builder] = ModalFormBuilder
    options[:remote] = true
    options[:html] = { class: 'form-horizontal modal-form' }
    form_for(object, options, &block)
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).build
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to('#', class: "add-fields", data: { id: id, fields: fields.gsub("\n", "") }) do
      content_tag(:i, nil, class: "fa fa-plus") + name
    end
  end

  def link_to_add_hstore_fields(label = "", fields_partial)
    fields = render(fields_partial).gsub("\n", "")
    link_to('#', class: "add-hstore-fields", data: { fields: fields }) do
      content_tag(:i, nil, class: "fa fa-plus") + label
    end
  end

  def sort_link(column, title = nil)
    title ||= column.titleize
    arrow_direction = params[:direction] == "asc" ? "up" : "down" if params[:direction].present?
    icon = column == params[:sort] ? content_tag(:i, nil, class: "fa fa-caret-#{arrow_direction}").html_safe : ""
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    new_params = params.merge({ sort: column, direction: direction })
    link_to(title, new_params) + " " + icon
  end

  def link_to_modal_edit(path, object, options = {})
    link_to path, { :"data-toggle" => "modal", :"data-target" => "#forms-modal", id: "#{object.class.to_s.downcase}-#{object.id}-edit", class: options[:class] } do
      content_tag(:i, nil, class: "fa fa-edit").html_safe
    end
  end

  def link_to_modal_new(path, label)
    content_tag(:th, nil, colspan: "100%") do
      link_to label, path, { class: "btn btn-primary btn-block text-center", :"data-toggle" => "modal", :"data-target" => "#forms-modal" }
    end
  end

  def link_to_export(route_helper, params)
    if current_user.admin?
      export_params = params.merge(format: "csv")
      link_to "Export", route_helper.call(export_params), class: "btn btn-default"
    end
  end

  def link_to_delete_if_admin(object)
    if current_user.admin?
      link_to "Delete", object, method: :delete, remote: true, class: "btn btn-danger pull-left"
    end
  end
end
