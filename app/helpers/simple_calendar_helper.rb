module SimpleCalendarHelper
  def calendar_header
    -> { { class: "calendar-header" } }
  end

  def calendar_title
    ->(date) do 
      content_tag :h2, "#{date.strftime("%B")} #{date.year}", class: "calendar-title" 
    end
  end

  def calendar_previous_link
    ->(param, date_range) do 
      link_to content_tag(:i,"", class: 'fa fa-chevron-left fa-lg'), { param => date_range.first - 1.day }
    end
  end

  def calendar_next_link
    ->(param, date_range) do 
      link_to content_tag(:i,"", class: 'fa fa-chevron-right fa-lg'), { param => date_range.last + 1.day }
    end
  end

  def calendar_table
    -> { { class: "calendar-table table table-bordered" } }
  end

  def calendar_td
    ->(start_date, current_calendar_date) do
      today = Date.current
      td_class = ["day"]
      td_class << "info" if today == current_calendar_date
      td_class << "non-month" if start_date.month != current_calendar_date.month
      { class: td_class, data: { day: current_calendar_date } }
    end
  end
end
