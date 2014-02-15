class Tenant
  PROPERTIES = { 
    'pi' => { name: "PI",
              time_zone: "Central Time (US & Canada)", 
              area_divisor: 144.0, 
              small_area_cutoff: 2304, 
              yield_multiplier: 1 },
    'pe' => { name: "PE",
              time_zone: "Beijing", 
              area_divisor: 1000000.0, 
              small_area_cutoff: 1500000.0, 
              yield_multiplier: 10.76 }
  }

  attr_reader :name, :code, :time_zone, :area_divisor, :small_area_cutoff, :yield_multiplier

  def initialize(code)
    @code = code
    @time_zone = PROPERTIES[code][:time_zone]
    @area_divisor = PROPERTIES[code][:area_divisor]
    @small_area_cutoff = PROPERTIES[code][:small_area_cutoff]
    @yield_multiplier = PROPERTIES[code][:yield_multiplier]
  end

  def widget(klass, id)
    widgets(klass).find(id)
  end

  def widgets(klass)
    case
    when klass == Film
      klass.where(tenant_code: code).with_additional_fields(area_divisor)
    else
      Rails.logger.debug klass
      klass.where(tenant_code: code)
    end
  end

  def new_widget(klass, *args)
    klass.new(*args).tap do |u|
      u.tenant_code = code
    end
  end
end
