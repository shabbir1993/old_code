module PhaseDefinitions
  def self.table_columns(phase)
    case phase
    when "inspection"
      { 
        'Eff W' => 'effective_width',
        'Eff L' => 'effective_length',
        'Eff area' => 'effective_area',
        'Reserved' => 'sales_order_code'
      }
    when "stock"
      {
        'Width' => 'width',
        'Length' => 'length',
        'Area' => 'area',
        'Shelf' => 'shelf',
        'Reserved' => 'sales_order_code'
      }
    when "fg", "wip"
      {
        'Width' => 'width',
        'Length' => 'length',
        'Area' => 'area',
        'Order' => 'sales_order_code'
      }
    when "nc", "scrap", "test"
      {
        'Width' => 'width',
        'Length' => 'length',
        'Area' => 'area',
        'Shelf' => 'shelf'
      }
    else
      {}
    end
  end

  def self.edit_fields(phase)
    case phase
    when "inspection"
      %w(effective_dimension_fields)
    when "stock"
      %w(dimension_fields shelf_fields sales_order_fields)
    when "fg", "wip"
      %w(dimension_fields sales_order_fields)
    when "nc", "scrap", "test"
      %w(dimension_fields shelf_fields)
    else
      []
    end
  end
end
