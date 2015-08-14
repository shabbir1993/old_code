module JobDatesHelper
  def step_icon(step)
    shared_classes = "label pull-right"
    case step
    when "released"
      content_tag :span, class: "#{shared_classes} label-success" do
        "Rel"
      end
    when "due"
      content_tag :span, class: "#{shared_classes} label-danger" do
        "Due"
      end
    else
      content_tag :span, class: "#{shared_classes} label-warning" do
        step
      end
    end
  end
end
