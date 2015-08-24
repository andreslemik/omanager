class OptionValue < ActiveRecord::Base
  acts_as_list scope: :option_type
  belongs_to :option_type, touch: true, inverse_of: :option_values

  validates :name, presence: true, uniqueness: { scope: :option_type_id }

  default_scope { order 'option_type_id, position' }

  def full_name
    "#{self.option_type.name}: #{self.name}"
  end

end
