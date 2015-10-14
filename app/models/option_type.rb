# app/models/option_type.rb
class OptionType < ActiveRecord::Base
  acts_as_list
  validates :name, presence: true, uniqueness: true

  default_scope { order("#{table_name}.position") }

  has_many :product_option_types, dependent: :destroy,
                                  inverse_of: :option_type
  has_many :option_values, -> { order(:position) }, dependent: :destroy,
                                                    inverse_of: :option_type
  accepts_nested_attributes_for :option_values,
                                reject_if: ->(ov) { ov[:name].blank? },
                                allow_destroy: true

  def option_values_string
    (option_values.map(&:name).join ', ').truncate(30)
  end
end
