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

  def fg_utilization
    all_movements_to_fg = FilmMovement.fg.includes(film: :master_film)
    @data = all_movements_to_fg.map do |movement|
      {
        datetime: movement.created_at.to_i*1000, 
        utilization: (movement.film.utilization*100 if movement.film && movement.film.utilization), 
        serial: (movement.film.master_film.serial if movement.film)
      }
    end
  end

  def master_film_yield
    @data = MasterFilm.where("effective_width IS NOT NULL AND effective_length IS NOT NULL AND mix_mass IS NOT NULL AND machine_id IS NOT NULL").group_by(&:formula)
  end

  def stock_dimensions
    all_film_dimensions = Film.phase("stock").large.includes(:master_film).count(:all, group: ['master_films.formula', :length, :width]).map do |k, v|
      k << v
    end
    @data = all_film_dimensions.group_by(&:first)
  end
end
