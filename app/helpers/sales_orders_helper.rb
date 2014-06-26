module SalesOrdersHelper
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
