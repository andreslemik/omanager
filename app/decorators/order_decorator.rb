# app/decorators/order_decorator.rb
class OrderDecorator < ApplicationDecorator
  delegate_all

  def balance
    h.content_tag :span, class: 'balance' do
      h.number_to_currency(object.total - object.income_total,
                           precision: 0, unit: '')
    end
  end
  def items_names
    order_items.map { |oi| "#{oi.product.name} (#{oi.product.category.name})" }
        .join(', ')
  end
  def to_s
    "Договор №#{dog_num_s} от #{I18n.l order_date}"
  end
  def dog_num_s
    dog_num.blank? ? 'б/н' : dog_num
  end
end
