module OrdersHelper
  def order_items_text(order)
    result = ''
    order.order_items.to_fabrication.each do |oi|
      result << content_tag(:span, oi.product.name, title: oi.product.category.name)
      result << '<br />' unless oi == order.order_items.last
    end
    result
  end
end