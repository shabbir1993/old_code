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
    params[:start_date] ||= Date.current.to_s
    params[:end_date] ||= (Date.current + 1).to_s
    film_movements = PaperTrail::Version.search_date_range(params[:start_date], params[:end_date]).movements
    film_movements_by_phase_change = film_movements.group_by(&:phase_change)
    @film_movements_by_phase_change = Hash[film_movements_by_phase_change.map { |k,v| [k, [(v ? v.count : 0), v.map{ |ver| ver.area_after }.sum.to_f.round(2) ]] }]
    @phases_in_order = %w(raw lamination inspection stock wip fg test nc scrap)
  end

  def shelf_inventory
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
    sales_orders = SalesOrder.shipped.ship_date_range(params[:start_date], params[:end_date])
    dates = (params[:start_date] || SalesOrder.minimum(:ship_date))..(params[:end_date] || SalesOrder.maximum(:ship_date))
    @film_area_shipped_by_date = dates.map{ |d| [d, sales_orders.with_ship_date(d).total_custom_area_by_product_type("Film").round(2) ] }
    @glass_area_shipped_by_date = dates.map{ |d| [d, sales_orders.with_ship_date(d).total_custom_area_by_product_type("Glass").round(2) ] }
    @total_film_area_shipped = sales_orders.total_custom_area_by_product_type("Film").round(2)
    @total_glass_area_shipped = sales_orders.total_custom_area_by_product_type("Glass").round(2)
  end
end
