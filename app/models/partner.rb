class Partner < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'PartnerAuthorizer'
  acts_as_paranoid

  validates :name, uniqueness: { conditions: -> { where(deleted_at: nil) } }, presence: true
  validates :partner_type, presence: true

  has_many :operations, as: :accountable, class_name: 'Account', dependent: :destroy

  has_many :products, foreign_key: :manufacturer_id
  has_many :orders


  enum partner_type: { supplier: 0, customer: 1 }

  scope :suppliers, -> { where partner_type: 0 }
  scope :customers, -> { where partner_type: 1 }

  def balance
    income = operations.income.map(&:amount).sum
    expense = operations.expense.map(&:amount).sum
    income - expense
  end


end
