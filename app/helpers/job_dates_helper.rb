module JobDatesHelper
  def step_icon(job_date)
    shared_classes = "label pull-right"
    if job_date.step == "released"
      content_tag :span, class: "#{shared_classes} label-success" do
        "Rel"
      end
    elsif job_date.step == "due" && job_date.job_order.supermarket?
      content_tag :span, class: "#{shared_classes} label-warning" do
        "Due"
      end
    elsif job_date.step == "due"
      content_tag :span, class: "#{shared_classes} label-danger" do
        "Due"
      end
    else
      content_tag :span, class: "#{shared_classes} label-default" do
        step
      end
    end
  end
end
