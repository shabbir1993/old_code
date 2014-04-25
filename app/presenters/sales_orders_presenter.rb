class SalesOrdersPresenter
  attr_reader :sales_orders

  def initialize(tenant, inputs)
    @sales_orders = tenant.widgets(SalesOrder)
    @inputs = inputs
  end

  def present
    @results ||= sales_orders.send(@inputs[:status])
                             .filter(filtering_params)
                             .by_code
  end

  def total_orders
    present.count(:all)
  end

  def total_area
    present.to_a.map{ |o| o.total_custom_area }.sum.round(2)
  end

  def total_pieces
    if @status == 'unshipped'
      present.to_a.map{ |o| o.total_quantity }.sum - SalesOrder.find_by(code: 'SAMPLE').total_quantity
    else
      present.to_a.map{ |o| o.total_quantity }.sum
    end
  end

  private

  def filtering_params
    @inputs.slice(:text_search, :ship_date_before, :ship_date_after)
  end
end
