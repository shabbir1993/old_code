module JobDatesHelper
  def step_icon(display_step)
    label_color = case display_step
                  when "released"
                    "LimeGreen"
                  when "YR"
                    "LightYellow"
                  when "WR"
                    "Yellow"
                  when "fill"
                    "Gold"
                  when "ET"
                    "Orange"
                  when "SM"
                    "DarkOrange"
                  when "mask"
                    "Black"
                  when "PLZ"
                    "Gray"
                  when "BE"
                    "LightSteelBlue"
                  when "QC"
                    "Pink"
                  when "FG"
                    "Red"
                  else
                    raise "invalid step"
                  end

    content_tag :span, class: "label pull-right label-default", style: "background-color: #{label_color};" do
      display_step
    end
  end
end
