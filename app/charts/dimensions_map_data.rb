class DimensionsMapData
  def initialize(records)
    @records = records
  end

  def map_hash
    records_grouped_by_coordinates.map do |k,v|
      { coords: k, value: v.count, serials: pluck_serials(v) }
    end
  end

  def x_axis_categories
    (0..max_x_coordinate) .map { |c| "#{c*interval}-#{c*interval + (interval-1)}" }
  end

  def y_axis_categories
    (0..max_y_coordinate).map { |c| "#{c*interval}-#{c*interval + (interval-1)}" }
  end

  def max_x_coordinate
    convert_to_coordinate(@records.maximum(:length))
  end

  def max_y_coordinate
    convert_to_coordinate(@records.maximum(:width))
  end

  private

  def records_grouped_by_coordinates
    @records.group_by{ |r| [convert_to_coordinate(r.length), convert_to_coordinate(r.width)] }
  end

  def convert_to_coordinate(dimension)
    ((dimension || 0)/interval).round
  end

  def pluck_serials(array)
    array.map { |i| i.serial }
  end

  def interval
    5
  end
end
