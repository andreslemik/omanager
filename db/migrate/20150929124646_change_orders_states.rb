class ChangeOrdersStates < ActiveRecord::Migration
  def change
    Order.find_each do |o|
      if o.all_items_ready?
        o.aasm_state = 'ready'
        o.save
      end
      if o.all_items_done?
        o.aasm_state = 'done'
        o.save
      end
    end
  end
end
