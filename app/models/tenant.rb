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

  attr_reader :code, :name, :time_zone, :area_divisor, :small_area_cutoff, :yield_multiplier

  def initialize(code)
    @code = code
    @name = PROPERTIES[code][:name]
    @time_zone = PROPERTIES[code][:time_zone]
    @area_divisor = PROPERTIES[code][:area_divisor]
    @small_area_cutoff = PROPERTIES[code][:small_area_cutoff]
    @yield_multiplier = PROPERTIES[code][:yield_multiplier]
  end

  private

  def self.asset_classes
    [User, FilmMovement, SalesOrder, MasterFilm, Film, Machine]
  end

  asset_classes.each do |klass|
    name = klass.name.pluralize.underscore.downcase.to_sym
    define_method(name) do
      klass.tenant(code)
    end
  end

  asset_classes.each do |klass|
    name = "new_#{klass.name.underscore.downcase}".to_sym
    define_method(name) do |*args|
      klass.new(*args).tap do |o|
        o.tenant_code = code
      end
    end
  end
end
