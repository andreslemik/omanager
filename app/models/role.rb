class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  validates :name, presence: true, uniqueness: true
  validates :caption, presence: true

  def users_s
    users.map(&:name).join ', '
  end

end