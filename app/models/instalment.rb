class Instalment < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :order
end
