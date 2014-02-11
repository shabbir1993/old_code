class ModalFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, to: :@template

  %w[text_field text_area password_field collection_select select number_field].each do |method_name|
    define_method(method_name) do |name, *args|
      options = args.extract_options!
      if options[:default]
        args << options.except(:default)
        args = add_default_class(args)
        super(name, *args)
      else
        args << options if options.present?
        args = add_default_class(args)
        content_tag :div, class: "form-group" do
          field_label(name, *args) +
          content_tag(:div, super(name, *args), class: "col-md-8")
        end
      end
    end
  end

  def check_box(name, *args)
    content_tag :div, class: "form-group" do
      content_tag :div, class: "col-md-offset-2 col-md-6" do
        content_tag :div, class: "checkbox" do
          label(name) +
          super(name)
        end
      end
    end
  end

  def inline_radio(name, value, label_text, *args)
    label value, class: "radio-inline" do
      radio_button(name, value) + label_text
    end
  end

private

  def field_label(name, *args)
    options = args.extract_options!
    if options[:label] == false
      label(' ', ' ', class: "control-label col-md-2")
    else
      label(name, options[:label], class: "control-label col-md-2")
    end
  end

  def add_default_class(args)
    if args.last && args.last.is_a?(Hash) && !args.last.has_key?(:class)
      args.last[:class] = "form-control"
    elsif args.empty? || !args.last.is_a?(Hash)
      args << { class: "form-control" }
    end
    args
  end
end
