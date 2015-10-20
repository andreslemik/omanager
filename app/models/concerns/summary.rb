# app/models/concerns/summary.rb
module Summary
  extend ActiveSupport::Concern

  module ClassMethods
    def summary(field)
      pluck(field).sum
    end
  end
end
