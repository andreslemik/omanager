# app/models/concerns/summary.rb
module Summary
  extend ActiveSupport::Concern

  included do
    def self.summary
      pluck(:amount).sum
    end
  end
end
