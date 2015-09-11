# Account authorizer class
class AccountAuthorizer < ApplicationAuthorizer
  class << self
    def readable_by?(user)
      user.has_any_role? :admin, :accountant
    end
  end
end