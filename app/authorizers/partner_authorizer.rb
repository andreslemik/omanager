# Partner authorizer class
class PartnerAuthorizer < ApplicationAuthorizer
  class << self
    def readable_by?(user)
      user.has_any_role? :admin, :accountant
    end

    def updateable_by?(user)
      user.has_any_role? :admin, :accountant
    end
  end

end