class DimensionsMap
  INTERVAL = 5

  def initialize(records)
    @records = records
  end

  def map_hash
    records_grouped_by_coordinates.map do |k,v|
      { coords: k, value: v.count, serials: pluck_serials(v) }
    end
  end

  def x_axis_categories
    (0..max_x_coordinate).map { |c| "#{c*INTERVAL}-#{c*INTERVAL + (INTERVAL)}" }
  end

  def y_axis_categories
    (0..max_y_coordinate).map { |c| "#{c*INTERVAL}-#{c*INTERVAL + (INTERVAL)}" }
  end

  def max_x_coordinate
    convert_to_coordinate(@records.map(&:length).max)
  end

  def max_y_coordinate
    convert_to_coordinate(@records.map(&:width).max)
  end

  private

  def records_grouped_by_coordinates
    @records.group_by{ |r| [convert_to_coordinate(r.length), convert_to_coordinate(r.width)] }
  end

  def convert_to_coordinate(dimension)
    ((dimension || 0)/INTERVAL).round
  end

  def pluck_serials(array)
    array.map { |i| i.serial }
  end
end
