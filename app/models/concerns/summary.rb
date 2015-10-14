# app/models/concerns/summary.rb
module Summary
  extend ActiveSupport::Concern

  included do
    def self.summary(field)
      pluck(field).sum
      end
  end
end
