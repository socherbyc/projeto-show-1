class IssueShowService
  def initialize(params)
    @date_start = DateTime.new(
      params['issue']['date_start(1i)'].to_i,
      params['issue']['date_start(2i)'].to_i,
      params['issue']['date_start(3i)'].to_i)
    @date_end = DateTime.new(
      params['issue']['date_end(1i)'].to_i,
      params['issue']['date_end(2i)'].to_i,
      params['issue']['date_end(3i)'].to_i)
    
    @products = if params['products'].present? and params['products'].length > 0
      params['products']
    else
      nil
    end
    
    @by_time = ({'month' => 'YYYY-MM', 'year' => 'YYYY'})[params['by_time']]
  end

  def get_results
    order_query = Order.where('date >= ?', @date_start).where('date <= ?', @date_end)

    unless @products.nil?
      order_query = order_query.where("order_details.product_id": @products)
    end

    order_query = order_query \
      .joins("INNER JOIN order_details ON orders.number = order_details.order_number") \
      .order('_period').group('_period') \
      .select(
        "SUM(order_details.amount * order_details.price) _sum_price",
        "to_char(date, '#{@by_time}') _period"
      )
    
    order_query.to_a.map do |i|
        {
          "label" => i._period.split("-").reverse.join("/"),
          "total" => Money.new(i._sum_price * 100),
        }
      end
  end
end