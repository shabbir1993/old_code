class FormulaTotalsPresenter
  attr_reader :large_stock_films

  def initialize(tenant)
    @large_stock_films = tenant.widgets(Film).large_stock
  end

  def count_and_area_by_formula
    all_formula_types.map do |formula|
      films_of_formula = large_stock_films.where("master_films.formula = ?", formula)
      {
        formula: formula.present? ? formula : "None",
        count: films_of_formula.count,
        area: films_of_formula.map{ |f| f.area.to_f }.sum
      }
    end
  end

  private
  
  def all_formula_types
    large_stock_films.pluck("master_films.formula").uniq
  end
end
