class Instalment < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail
  belongs_to :order

  default_scope { order :payment_date }

end
