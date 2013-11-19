class ChartsController < ApplicationController
  def stock_film_type_totals
    all_film_types = Film.large_stock.joins(:master_film).pluck("master_films.film_code").uniq

    @data = all_film_types.map do |type|
      {
        film_type: type.present? ? type : "None",
        count: Film.large_stock.joins(:master_film).where("master_films.film_code = ?", type).count,
        total_area: Film.large_stock.joins(:master_film).where("master_films.film_code = ?", type).sum("width * length / 144").to_i
      }
    end
  end

  def stock_formula_totals
    all_film_formulas = Film.large_stock.joins(:master_film).pluck("master_films.formula").uniq

    @data = all_film_formulas.map do |formula|
      {
        film_formula: formula.present? ? formula : "None",
        count: Film.large_stock.joins(:master_film).where("master_films.formula = ?", formula).count,
        total_area: Film.large_stock.joins(:master_film).where("master_films.formula = ?", formula).sum("width * length / 144").to_i
      }
    end
  end

  def stock_dimensions
    all_film_dimensions = Film.large_stock.includes(:master_film).count(:all, group: ['master_films.formula', :length, :width]).map do |k, v|
      k << v
    end
    @data = all_film_dimensions.group_by(&:first)
  end

  def stock_snapshots
    @stock_data = PhaseSnapshot.where(phase: "large_stock").select("count, total_area, created_at").order("created_at ASC")
    @reserved_stock_data = PhaseSnapshot.where(phase: "reserved_stock").select("count, total_area, created_at").order("created_at ASC")
  end

  def movement_summary
    if params[:start_date] && params[:end_date]
      data = PaperTrail::Version.where("created_at BETWEEN ? AND ?", Time.zone.parse(params[:start_date]), Time.zone.parse(params[:end_date]))
    else
      data = PaperTrail::Version.all
    end
    data = data.where("'phase' = ANY (columns_changed)").select("phase_change, area_change").group_by(&:phase_change)
    @data = Hash[data.map { |k,v| [k, [(v ? v.count : 0), v.sum { |v| (v.area_change ? v.area_change[1] : nil) || 0 }.to_f ]] }]
    @phases_in_order = %w(raw lamination inspection stock wip fg test nc scrap)
  end
end
