module FilmsHelper
  def visible_columns_for(scope)
    case scope
    when "lamination"
      ['Mix/g', 'Mach', 'ITO', 'Thinky', 'Chemist', 'Operator']
    when "inspection"
      ['Eff W', 'Eff L', 'Eff Area', 'Defects']
    when "large_stock","small_stock", "reserved_stock", "nc", "scrap", "test"
      ['Shelf', 'Width', 'Length', 'Area']
    when "wip", "fg"
      ['Customer', 'SO#', 'Custom W', 'Custom L', 'Custom Area',
       'Util', 'Width', 'Length', 'Area']
    when "deleted"
      ['Phase', 'Width', 'Length']
    else
      []
    end
  end

  def column_headers_for(scope)
    visible_columns_for(scope).map do |header|
      content_tag(:th, header)
    end.join.html_safe
  end

  def table_values_for(deleted, phase, film)
    if deleted
      render "deleted_table_values", film: film
    else
      case phase
      when "lamination"
        render "lamination_table_values", film: film
      when "inspection"
        render "inspection_table_values", film: film
      when "stock", "nc", "scrap", "test"
        render "backend_table_values", film: film
      when "wip", "fg"
        render "checkout_table_values", film: film
      end
    end
  end

  def edit_fields_for(phase, f)
    case phase
    when "lamination"
      render "lamination_fields", f: f
    when "inspection"
      render "inspection_fields", f: f
    when "stock", "nc", "scrap", "test"
      render "backend_fields", f: f
    when "wip", "fg"
      render "checkout_fields", f: f
    end
  end
end
