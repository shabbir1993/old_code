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
end
