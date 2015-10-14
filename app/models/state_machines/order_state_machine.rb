module StateMachines::OrderStateMachine
  def self.included(base)
    base.send(:include, AASM)
    base.aasm do
      state :pending, inital: true
      state :working
      state :ready
      state :done
      state :canceled

      event :work do
        transitions from: :pending, to: :working
      end
      event :stop_work do
        transitions from: :working, to: :pending, guard: :all_items_pending?
      end
      event :get_ready do
        transitions from: :working, to: :ready, guard: :all_items_ready?
      end
      event :done do
        transitions from: :ready, to: :done,
                    guard: [:all_items_done?, :accounting_done?]
      end
      event :cancel do
        transitions from: [:pending, :working], to: :canceled
      end
    end
  end
end