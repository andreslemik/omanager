# app/decorators/order_decorator.rb
class OrderDecorator < ApplicationDecorator
  delegate_all

  def balance
    h.content_tag :span, class: 'balance' do
      h.number_to_currency(object.total - object.income_total,
                           precision: 0, unit: '')
    end
  end
end
