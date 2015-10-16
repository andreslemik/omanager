# app/models/account.rb
class Account < ActiveRecord::Base
  include Authority::Abilities
  include Summary
  self.authorizer_name = 'AccountAuthorizer'
  acts_as_paranoid
  has_paper_trail
  enum operation_type: { expense: 0, income: 1 }
  paginates_per 15

  validates :operation_date, :operation_type, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  belongs_to :accountable, polymorphic: true
  belongs_to :dept

  scope :expense, -> { where operation_type: 0 }
  scope :income, -> { where operation_type: 1 }
  scope :on_date, -> (date) { where('operation_date <= ?', date) }
  scope :after_date, -> (date) { where('operation_date > ?', date) }

  def to_s
    "Денежная операция от #{I18n.l updated_at}"
  end
end
