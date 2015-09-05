# Order authorizer class
class OrderAuthorizer < ApplicationAuthorizer
  def self.readable_by?(user)
    user.has_any_role? :admin, :manager, :fabrication
  end

  def self.updatable_by?(user)
    user.has_any_role? :manager, :admin
  end

  def updatable_by?(user)
    return true if user.has_role? :admin
    resource.aasm_state == 'pending' && user.has_role?(:manager)
  end

  def readable_by?(_user)
    true
  end
end
