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

  def link_to_modal_edit(path, object, options = {})
    link_to path, { :"data-toggle" => "modal", :"data-target" => "#forms-modal", id: "#{object.class.to_s.downcase}-#{object.id}-edit", class: options[:class] } do
      content_tag(:i, nil, class: "fa fa-edit").html_safe
    end
  end

  def link_to_modal_new(path, label)
    link_to path, { class: "btn btn-success", :"data-toggle" => "modal", :"data-target" => "#forms-modal" } do
      content_tag(:i, nil, class: "fa fa-plus") + " #{label}"
    end
  end

  def link_to_export(text, params)
    if current_user.admin?
      link_to url_for(params.merge(format: "csv")), class: "btn btn-default" do
        content_tag(:i, nil, class: "fa fa-download") + " " + text
      end
    end
  end

  def link_to_delete_if_admin(object)
    if current_user.admin?
      link_to "Delete", object, method: :delete, remote: true, class: "btn btn-danger pull-left"
    end
  end

  def sidebar_link_to(parameter, value, &block)
    link_to url_for(parameter => value), class: "list-group-item#{" active" if params[parameter] == value}" do
      yield
    end
  end

  def tab_link_to(text, action)
    content_tag(:li, class: params[:action] == action ? "active" : "") do
      link_to text, url_for(params.merge(action: action))
    end
  end
end
