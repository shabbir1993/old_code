class MasterFilmsPresenter
  attr_reader :master_films, :start_serial, :end_serial

  def initialize(tenant, inputs)
    @master_films = tenant.widgets(MasterFilm)
    @start_serial = inputs[:start_serial]
    @end_serial = inputs[:end_serial]
  end

  def present
    @results ||= master_films.active
                             .search(start_serial, end_serial)
                             .by_serial
                             .includes(:machine)
  end
end
