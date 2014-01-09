module ApplicationHelper
  def modal_form_for(object, options = {}, &block)
    options[:builder] = ModalFormBuilder
    options[:remote] = true
    options[:html] = { class: 'form-horizontal modal-form' }
    content_tag(:div, class: "modal-dialog #{options[:dialog_class]}") do
      content_tag(:div, class: "modal-content") do
        form_for(object, options, &block)
      end
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).build
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to('#', class: "add-fields", data: { id: id, fields: fields.gsub("\n", "") }) do
      content_tag(:span, nil, class: "glyphicon glyphicon-plus") + name
    end
  end

  def sort_link(column, title = nil)
    title ||= column.titleize
    arrow_direction = sort_direction == "asc" ? "up" : "down" if sort_direction.present?
    icon = column == sort_column ? content_tag(:span, nil, class: "glyphicon glyphicon-chevron-#{arrow_direction}").html_safe : ""
    direction = (column == sort_column && sort_direction == "desc") ? "asc" : "desc"
    new_params = params.merge({ sort: column, direction: direction })
    link_to(title, new_params) + icon
  end
end
