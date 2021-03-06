# app/models/role.rb
class Role < ActiveRecord::Base
  scopify

  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  validates :name, presence: true, uniqueness: true
  validates :caption, presence: true, if: -> { !Rails.env.test? }

  def users_s
    users.order(:last_name, :first_name).map(&:name).join ', '
  end
end
