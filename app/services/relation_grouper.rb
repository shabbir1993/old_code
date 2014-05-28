class RelationGrouper
  def initialize(klass, date_column, start_date, end_date)
    @klass = klass
    @date_column = date_column
    @start_date = start_date
    @end_date = end_date
  end

  def by_day
    date_ranges("day").map do |d|
      { sort_date: d[:after], 
        display_date: d[:after].strftime('%D'), 
        relation: relation(d[:after], d[:before])
      }
    end
  end

  def by_week
    date_ranges("week").map do |d|
      { sort_date: d[:after], 
        display_date: "#{d[:after].strftime('%D')} - #{d[:before].strftime('%D')}", 
        relation: relation(d[:after], d[:before]) 
      }
    end
  end

  def by_month
    date_ranges("month").map do |d|
      { sort_date: d[:after], 
        display_date: d[:after].strftime('%B %Y'),
        relation: relation(d[:after], d[:before]) 
      }
    end
  end

  def by_quarter
    date_ranges("quarter").map do |d|
      { sort_date: d[:after], 
        display_date: "#{quarter(d[:after])} #{d[:after].year}",
        relation: relation(d[:after], d[:before]) 
      }
    end
  end

  private

  def start_date
    @start_date.present? ? @start_date : @klass.minimum(@date_column)
  end

  def end_date
    @end_date.present? ? @end_date : @klass.maximum(@date_column)
  end

  def sorted_relevant_dates
    relation(start_date, end_date).pluck(@date_column).sort
  end


  def date_ranges(unit)
    sorted_relevant_dates.map do |d| 
      { 
        after: d.public_send("beginning_of_#{unit}").to_date, 
        before: d.public_send("end_of_#{unit}").to_date
      }
    end.uniq
  end

  def relation(after, before)
    @klass.public_send("#{@date_column}_after", after.to_s)
          .public_send("#{@date_column}_before", before.to_s)
  end

  def quarter(date)
    case date.month
    when 1..3
      "Q1"
    when 4..6
      "Q2"
    when 7..9
      "Q3"
    when 10..12
      "Q4"
    end
  end
end
