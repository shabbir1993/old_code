class TimeSeriesGrouper
  def initialize(relation, date_column)
    @relation = relation
    @date_column = date_column
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

  def sorted_relevant_dates
    @relation.pluck(@date_column).sort
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
    @relation.public_send("#{@date_column}_after", after.to_s)
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
