# app/models/state_machines/order_item_state_machine.rb
module StateMachines::OrderItemStateMachine
  def self.included(base)
    base.send(:include, AASM)
    base.aasm do
      state :pending, initial: true
      state :working
      state :ready
      state :delivery
      state :done
      state :customer

      event :work do
        after do
          order.work! if order.aasm.current_state == :pending
        end
        transitions from: :pending, to: :working
      end
      event :stop_work do
        after_commit do
          update_attribute(:fabrication_date, nil)
          order.stop_work! if order.all_items_pending?
        end
        transitions from: :working, to: :pending
      end
      event :get_ready do
        transitions from: [:working, :pending], to: :ready
        after_commit do
          order.get_ready! if order.all_items_ready?
        end
      end
      event :to_delivery do
        transitions from: [:ready, :done], to: :delivery
      end
      event :undo_delivery do
        after_commit do
          update_attribute(:delivery_date, nil)
        end
        transitions from: :delivery, to: :ready
      end
      event :well_done do
        transitions from: :delivery, to: :done
      end
      event :to_customer do
        transitions from: :delivery, to: :customer
        after_commit do
          update_attribute(:dept_id, nil)
        end
      end
    end
  end
end
