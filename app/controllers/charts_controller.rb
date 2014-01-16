class ChartsController < ApplicationController
  def stock_film_type_totals
    all_film_types = Film.large_stock.pluck("master_films.film_code").uniq

    @data = all_film_types.map do |type|
      {
        film_type: type.present? ? type : "None",
        count: Film.large_stock.where("master_films.film_code = ?", type).count,
        total_area: Film.large_stock.where("master_films.film_code = ?", type).sum("width * length / #{current_tenant.area_divisor}").to_i
      }
    end
  end

  def stock_formula_totals
    all_film_formulas = Film.large_stock.pluck("master_films.formula").uniq

    @data = all_film_formulas.map do |formula|
      {
        film_formula: formula.present? ? formula : "None",
        count: Film.large_stock.where("master_films.formula = ?", formula).count,
        total_area: Film.large_stock.where("master_films.formula = ?", formula).sum("width * length / #{current_tenant.area_divisor}").to_i
      }
    end
  end

  def stock_dimensions
    all_film_dimensions = Film.phase("stock").large.not_reserved.includes(:master_film).count(:all, group: ['master_films.formula', :length, :width]).map do |k, v|
      k << v
    end
    @data = all_film_dimensions.group_by(&:first)
  end

  def stock_snapshots
    @stock_data = PhaseSnapshot.where(phase: "large_stock").select("count, total_area, created_at").order("created_at ASC")
    @reserved_stock_data = PhaseSnapshot.where(phase: "reserved_stock").select("count, total_area, created_at").order("created_at ASC")
  end

  def movement_summary
    data = PaperTrail::Version.search_date_range(params[:start_date], params[:end_date])
    data = data.where("'phase' = ANY (columns_changed)").select("phase_change, area_change").group_by(&:phase_change)
    @data = Hash[data.map { |k,v| [k, [(v ? v.count : 0), v.sum { |v| (v.area_change ? v.area_change[1] : nil) || 0 }.to_f.round(2) ]] }]
    @phases_in_order = %w(raw lamination inspection stock wip fg test nc scrap)
  end

  def inventory
    @data = Film.phase("stock").large.order("shelf ASC").group_by(&:shelf)
  end

  def utilization
    data = SalesOrder.shipped.where(ship_date: params[:start_date]..params[:end_date])
    data = data.by_code.reverse
    @data = data
    @average = data.sum{ |d| d.utilization.to_f }/data.count if data.count != 0
  end

  def yield
    data = MasterFilm.where("serial BETWEEN ? AND ?", params[:start_serial], params[:end_serial]).by_serial.reverse
    @data = data.map{ |d| { serial: d.serial, yield: d.yield } }
    @average = data.sum{ |d| d.yield.to_f }/data.count if data.count != 0
  end

  def area_shipped
    data = SalesOrder.shipped.where(ship_date: params[:start_date]..params[:end_date]).group_by(&:ship_date)
    @film_shipped = data.map{ |k,v| [k, v.map{ |s| s.total_custom_area_by_product_type("Film") }.sum ] }
    @glass_shipped = data.map{ |k,v| [k, v.map{ |s| s.total_custom_area_by_product_type("Glass") }.sum ] }
    @total_film_shipped = SalesOrder.shipped.where(ship_date: params[:start_date]..params[:end_date]).map{ |s| s.total_custom_area_by_product_type("Film") }.sum
    @total_glass_shipped = SalesOrder.shipped.where(ship_date: params[:start_date]..params[:end_date]).map{ |s| s.total_custom_area_by_product_type("Glass") }.sum
  end
end
