class RelationGrouper
  def initialize(klass, date_attr)
    @klass = klass
    @date_attr = date_attr
  end

  def group_by_day
    @klass.sort_by(date_attr)
  end
end
