class SalesOrdersPresenter
  attr_reader :sales_orders, :status, :query

  def initialize(tenant, inputs)
    @sales_orders = tenant.widgets(SalesOrder)
    @status = inputs[:status]
    @query = inputs[:query]
  end

  def present
    @results ||= sales_orders.send(status)
                             .text_search(query)
                             .by_code
  end

  def total_orders
    present.count
  end

  def total_area
    present.sum{ |o| o.total_custom_area }.round(2)
  end

  def total_pieces
    if @status == 'unshipped'
      present.sum{ |o| o.total_quantity } - SalesOrder.find_by_code('SAMPLE').total_quantity
    else
      present.sum{ |o| o.total_quantity }
    end
  end
end
