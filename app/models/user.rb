class User < ActiveRecord::Base
  rolify
  acts_as_paranoid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  validates :password, :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true

  def name
    [last_name, first_name].compact.join(' ')
  end

end
