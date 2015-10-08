# app/decorators/order_item_decorator.rb
class OrderItemDecorator < ApplicationDecorator
  delegate_all

  def to_s
    "Позиция заказа №#{order.dog_num} от #{I18n.l order.order_date}"
  end

  def additional
    [descr_basis, descr_assort, special_notes].join ' / '
  end

  def product_options
    return '' if option_values.blank?
    result = []
    ov = OptionValue.where(id: option_values)
    ov.map { |v| "#{v.option_type}: #{v.name}" }
    result.join(', ')
  end

  def client_name
    return order.partner.name if order.dealer?
    return 'Внутренний' if order.order_type == 'internal'
    order.client
  end

end
