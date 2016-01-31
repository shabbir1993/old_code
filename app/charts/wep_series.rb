class WepSeries
  def initialize(records)
    @master_films = records
  end

  def data
    @master_films.reorder('master_films.serial ASC').map do |mf|
      [mf.serial, mf.wep_visible_on.to_f, mf.wep_ir_off.to_f]
    end
  end
end
