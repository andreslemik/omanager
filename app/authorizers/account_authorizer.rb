# Account authorizer class
class AccountAuthorizer < ApplicationAuthorizer
  class << self
    def readable_by?(user)
      user.has_any_role? :admin, :accountant
    end

    def updatable_by?(user)
      user.has_any_role? :admin, :accountant
    end

    def creatable_by?(user)
      user.has_any_role? :admin, :accountant, :manager
    end

    def deletable_by?(user)
      user.has_any_role? :admin, :accountant
    end
  end

  def updatable_by?(user)
    return false if partner_order_expense?(resource)
    return true if user.has_role?(:admin)
    Time.now - resource.created_at < 30.days && user.has_role?(:accountant)
  end

  def deletable_by?(user)
    return false if partner_order_expense?(resource)
    return true if user.has_role?(:admin)
    Time.now - resource.created_at < 10.minutes && user.has_role?(:accountant)
  end

  private

  def partner_order_expense?(resource)
    !resource.order_id.nil? &&
      resource.operation_type == 'expense' &&
      resource.accountable_type == 'Partner'
  end
end
