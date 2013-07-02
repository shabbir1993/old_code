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
    when "stock", "nc", "scrap", "testing"
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
      lamination_fields(f)
    when "inspection"
      inspection_fields(f)
    when "stock", "nc", "scrap", "testing"
      backend_fields(f)
    when "wip", "fg"
      checkout_fields(f)
    end
  end

  def lamination_fields(f)
    f.fields_for :master_film do |mff|
      mff.number_field(:mix_mass) +
      mff.collection_select(:machine_id, Machine.all, :id, :code) +
      mff.text_field(:film_code) +
      mff.text_field(:thinky_code) +
      mff.collection_select(:chemist_id, User.chemists, :id, :name) +
      mff.collection_select(:operator_id, User.operators, :id, :name)
    end
  end

  def inspection_fields(f)
    f.fields_for :master_film do |mff|
      mff.number_field(:effective_width) +
      mff.number_field(:effective_length)
    end
  end

  def backend_fields(f)
    f.text_field(:shelf) +
    f.number_field(:width) +
    f.number_field(:length)
  end

  def checkout_fields(f)
    f.number_field(:width) +
    f.number_field(:length) +
    f.text_field(:customer) +
    f.text_field(:sales_order_code) +
    f.number_field(:custom_width) +
    f.number_field(:custom_length) 
  end

  def movement_fieldsets(phase, f)
    case phase
    when "inspection"
      move_to_checkout_fieldset(f) +
      move_to_backend_fieldset(f)
    when "stock"
      move_to_checkout_fieldset(f)
    when "wip", "fg"
      move_to_backend_fieldset(f)
    end
  end

  def move_to_checkout_fieldset(f)
    field_set_tag 'Checkout fields', class: "checkout-fields movement-fields" do
      f.text_field(:customer) +
      f.text_field(:sales_order_code) +
      f.number_field(:custom_width) +
      f.number_field(:custom_length)
    end
  end

  def move_to_backend_fieldset(f)
    field_set_tag 'Backend fields', class: "backend-fields movement-fields" do
      f.text_field(:shelf)
    end
  end
end
