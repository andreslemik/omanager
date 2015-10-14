# app/models/user.rb
class User < ActiveRecord::Base
  rolify
  acts_as_paranoid
  include Authority::UserAbilities

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :password, :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true
  validates :username,
            presence: true,
            uniqueness: {
              case_sensitive: false
            }

  def name
    [last_name, first_name].compact.join(' ')
  end

  def roles_s
    roles.map(&:caption).join ', '
  end

  def login_key=(login)
    @login = login
  end

  def login_key
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login_key)
      where(conditions.to_h)
        .where(['lower(username) = :value OR lower(email) = :value', \
                { value: login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end
end
