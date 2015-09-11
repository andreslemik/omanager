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
      user.has_any_role? :admin, :accountant
    end

  end

  def updatable_by?(user)
    return true if user.has_role? :admin
    Time.now - resource.created_at < 30.days && user.has_role?(:accountant)
  end

end