module SalesOrdersHelper
  def phase_label_class(film)
    case film.phase
    when "wip"
      "label-warning"
    when "fg"
      "label-success"
    when "reserved"
      "label-danger"
    else
      "label-default"
    end
  end
end
