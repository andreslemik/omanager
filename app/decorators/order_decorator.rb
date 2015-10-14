# app/decorators/order_decorator.rb
class OrderDecorator < ApplicationDecorator
  delegate_all

  def balance
    return '-' unless retail?
    h.content_tag :span, class: 'balance' do
      h.number_to_currency(object.total - object.income_total,
                           precision: 0, unit: '')
    end
  end

  def balance_unformatted
    return '' unless retail?
    total - income_total
  end

  def total_summ
    h.number_to_currency(object.total, precision: 0, unit: '')
  end

  def items_names
    order_items.map { |oi| "#{oi.product.name} (#{oi.product.category.name})" }
      .join(', ')
  end

  def items_ids
    order_items.map(&:id).join(', ')
  end

  def to_s
    "Договор №#{dog_num_s} от #{I18n.l order_date}"
  end

  def formatted_balance_at(date)
    h.number_to_currency(balance_at(date), precision: 0, unit: '')
  end

  def dog_num_s
    return "[#{items_ids}]" if internal?
    dog_num.blank? ? 'б/н' : dog_num
  end

  def order_type_s
    # short order_type
    case order_type
    when 'retail'
      return 'ЧЗ'
    when 'dealer'
      return "ДЗ: #{partner.name}"
    when 'internal'
      return 'ВН'
    end
  end

  def partner_name
    return 'Внутренний заказ' if order_type == 'internal'
    partner.name
  end

  def client_name
    case order_type
      when 'internal'
        'Внутренний заказ'
      when 'dealer'
        partner.name
      when 'retail'
        client << ' ' << phone
    end
  end

  def delivery_address
    case order_type
      when 'internal'
        dept.try(:name)
      when 'dealer'
        partner_name
      when 'retail'
        address
    end
  end
end
