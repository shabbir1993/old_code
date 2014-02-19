module SalesOrdersHelper
  def link_to_ship_or_return(sales_order)
    if !sales_order.ship_date.present? && !sales_order.cancelled?
      link_to edit_ship_date_sales_order_path(sales_order), { :"data-toggle" => "modal", :"data-target" => "#forms-modal", id: "salesorder-#{sales_order.id}-ship", class: "pull-right" } do 
        content_tag(:i, nil, class: "fa fa-truck fa-flip-horizontal")
      end 
    elsif current_user.is_admin?
      link_to return_sales_order_path(sales_order), method: :patch, remote: true, id: "salesorder-#{sales_order.id}-return", class: "pull-right" do 
        content_tag(:i, nil, class: "fa fa-reply")
      end 
    end 
  end

  def display_status(sales_order)
    if sales_order.cancelled?
      content_tag(:span, class: "pull-right text-warning") do
        "Cancelled"
      end
    elsif sales_order.ship_date.present?
      content_tag(:span, class: "pull-right text-success") do
        "Shipped on #{sales_order.ship_date}"
      end
    end
  end

  def code_input_if_admin(form)
    form.text_field :code, label: "SO#" if current_user.is_admin?
  end
end
