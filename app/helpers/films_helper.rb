module FilmsHelper
  def variable_columns
    { 'Eff W' => 'effective_width',
      'Eff L' => 'effective_length',
      'Eff Area' => 'effective_area',
      'Defects' => 'defect_count',
      'Mix/g' => 'mix_mass', 
      'Mach' => 'machine_code', 
      'Film Type' => 'film_code', 
      'Thinky' => 'thinky_code', 
      'Chemist' => 'chemist_name', 
      'Operator' => 'operator_name', 
      'Shelf' => 'shelf',
      'Width' => 'width',
      'Length' => 'length',
      'Area' => 'area',
      'Customer' => 'customer',
      'SO#' => 'sales_order_code',
      'Custom W' => 'custom_width',
      'Custom L' => 'custom_length',
      'Custom Area' => 'custom_area',
      'Util' => 'utilization' }
  end
  
  def visible_columns_for(scope)
    case scope
    when "lamination"
      ['Mix/g', 'Mach', 'Film Type', 'Thinky', 'Chemist', 'Operator']
    when "inspection"
      ['Eff W', 'Eff L', 'Eff Area', 'Defects']
    when "large_stock","small_stock", "nc", "scrap", "testing"
      ['Shelf', 'Width', 'Length', 'Area']
    when "wip", "fg"
      ['Shelf', 'Customer', 'SO#', 'Custom W', 'Custom L', 'Custom Area',
       'Util', 'Width', 'Length', 'Area']
    else
      []
    end
  end

  def column_headers_for(scope)
    visible_columns_for(scope).map do |header|
      content_tag(:th, header)
    end.join.html_safe
  end
  
  def column_values_for(film, scope)
    visible_columns_for(scope).map do |key|
      content_tag(:td, film.send(variable_columns[key]), class: variable_columns[key])
    end.join.html_safe
  end

  def edit_fields_for(phase, f)
    case phase
    when "lamination"
      render "lamination_fields", f: f
    when "inspection"
      render "inspection_fields", f: f
    when "stock", "nc", "scrap", "testing"
      render "backend_fields", f: f
    when "wip", "fg"
      render "checkout_fields", f: f
    end
  end
end
