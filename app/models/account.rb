class Account < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail
  enum operation_type: { expense: 0, income: 1 }

  validates :operation_date, :operation_type, presence: true
  validates :amount, numericality: { greater_than: 0 }

  belongs_to :accountable, polymorphic: true

  scope :expense, -> { where operation_type: 0 }
  scope :income, -> { where operation_type: 1 }

end
