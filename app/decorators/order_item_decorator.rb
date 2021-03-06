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

  def product_name
    "#{product.name} (#{product.category.name}) [#{additional}]"
  end

  def dept_name
    return product.manufacturer.name if !product.manufacturer.own && dept_id.blank?
    dept.try(:name)
  end

  def delivery_memo_s
    if order_item.delivery_memo.blank?
      "#{order.memo}".html_safe
    else
      "#{order.memo}<br />Доставка: #{order_item.delivery_memo}".html_safe
    end
  end

  def delivery_memo_xls
    if order_item.delivery_memo.blank?
      "#{order.memo}".html_safe
    else
      "#{order.memo}\x0AДоставка: #{order_item.delivery_memo}".html_safe
    end
  end
end
