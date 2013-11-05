module ApplicationHelper
  def modal_form_for(object, options = {}, &block)
    options[:builder] = ModalFormBuilder
    options[:remote] = true
    options[:html] = { class: 'form-horizontal modal-form' }
    content_tag(:div, class: "modal-dialog") do
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
end
