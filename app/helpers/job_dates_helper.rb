module JobDatesHelper
  def step_icon(job_date)
    shared_classes = "label pull-right"
    if job_date.step == "released"
      content_tag :span, class: "#{shared_classes} label-success" do
        "Rel"
      end
    elsif job_date.step == "due" && job_date.job_order.supermarket?
      content_tag :span, class: "#{shared_classes} label-warning" do
        "SM"
      end
    elsif job_date.step == "due"
      content_tag :span, class: "#{shared_classes} label-danger" do
        "FG"
      end
    else
      content_tag :span, class: "#{shared_classes} label-default" do
        job_date.step
      end
    end
  end
end
