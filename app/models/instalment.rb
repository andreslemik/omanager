class Instalment < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail
  belongs_to :order

  default_scope { order :payment_date }
  scope :after_date, -> (date) { where('payment_date > ?', date) }

end
