class LabeledFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :tag, :image_tag, to: :@template

  %w[text_field text_area email_field password_field select collection_select 
     number_field check_box].each do |method_name|
    define_method(method_name) do |name, *args|
      content_tag :div, class: "control-group" do
        field_label(name, *args) + super(name, *args) + field_small(*args)
      end
    end
  end

  def labeled_file_field(name, *args)
    options = args.extract_options!
    content_tag :div, class: "control-group" do
      field_label(name, *args) + image_tag(options[:image_path]) + file_field(name, *args)
    end
  end

  def error_messages
    if object.errors.full_messages.any?
      content_tag(:div, :class => 'error-messages') do
        content_tag(:h2, "Invalid Fields") +
        content_tag(:ul) do
          object.errors.full_messages.map do |msg|
            content_tag(:li, msg)
          end.join.html_safe
        end
      end
    end
  end

  private

  def field_label(name, *args)
    options = args.extract_options!
    options[:label] == false ? "".html_safe : label(name, options[:label], class: "control-label")
  end

  def field_small(*args)
    options = args.extract_options!
    options[:small] ? content_tag(:small, options[:small]) : ""
  end

  def objectify_options(options)
    super.except(:label)
  end
end
