module JobDatesHelper
  def step_icon(display_step)
    label_color = case display_step
                  when "YR", "WR", "fill", "ET", "SM"
                    "LightSteelBlue"
                  when "PLZ", "BE", "QC", "FG", "released"
                    "Gray"
                  when "mask"
                    "Black"
                  else
                    raise "invalid step"
                  end

    content_tag :span, class: "label pull-right label-default", style: "background-color: #{label_color};" do
      display_step
    end
  end
end
