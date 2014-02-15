class MasterFilmsPresenter
  include Exportable

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

  def data_for_export
    types = present.defect_types
    data = [] << %w(Serial Formula Mix/g Machine ITO Thinky Chemist Operator EffW EffL Yield) + types
    present.limit(2000).each do |mf|
      data << [mf.serial, mf.formula, mf.mix_mass, mf.machine_code, mf.film_code, mf.thinky_code, mf.chemist, mf.operator, mf.effective_width, mf.effective_length, mf.yield] + types.map{ |type| mf.defect_count(type) }
    end
    data
  end
end
