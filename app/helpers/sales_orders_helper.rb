module SalesOrdersHelper
  def code_input_if_admin(form)
    form.text_field :code, label: "SO#" if current_user.admin?
  end

  def phase_label_class(film)
    case film.phase
    when "wip"
      "label-warning"
    when "fg"
      "label-success"
    else
      "label-danger"
    end
  end
end
