module OrdersHelper
  def order_items_text(order)
    result = ''
    order.order_items.to_fabrication.each do |oi|
      result << content_tag(:span,
                            oi.product.name,
                            title: oi.product.category.name, class: 'product-name')
      result << ' (' << content_tag(:span, oi.decorate.additional, class: 'product-additionals') << ')'
      result << '<br />' unless oi == order.order_items.last
    end
    result
  end

  def link_to_order(order)
    link_to order.decorate.dog_num_s, order_path(order)
  end

end
