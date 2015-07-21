class OptionType < ActiveRecord::Base
  acts_as_list
  validates :name, presence: true, uniqueness: true

  default_scope { order("#{self.table_name}.position") }


  has_many :product_option_types, dependent: :destroy, inverse_of: :option_type
  has_many :option_values, -> { order(:position) }, dependent: :destroy, inverse_of: :option_type
  accepts_nested_attributes_for :option_values,
                                reject_if: lambda { |ov| ov[:name].blank? },
                                allow_destroy: true


  #after_touch :touch_all_products

  def option_values_string
    (option_values.map(&:name).join ', ').truncate(30)
  end

  private

  def touch_all_products
    products.update_all(updated_at: Time.current)
  end

end
