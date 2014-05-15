class MasterFilmsPresenter
  include Exportable

  attr_reader :master_films, :start_serial, :end_serial, :query

  def initialize(tenant, inputs)
    @master_films = tenant.widgets(MasterFilm)
    @start_serial = inputs[:start_serial]
    @end_serial = inputs[:end_serial]
    @query = inputs[:query]
  end

  def present
    results = master_films.active
    results = results.serial_range(start_serial, end_serial)
    results = results.by_serial
    results = search_text(results)
    results
  end

  def search_text(master_films)
    if query.present?
      master_films.reorder('').search(query)
    else
      master_films
    end
  end
end
