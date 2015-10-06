require 'rails_helper'

describe Role, type: :model do
  before :all do
    FactoryGirl.create :manager, first_name: 'Иван', last_name: 'Иванов'
    FactoryGirl.create :manager, first_name: 'Петр', last_name: 'Петров'
  end

  it 'users_s return string with users of given role' do
    role = Role.find_by_name :manager
    expect(role.users_s).to eq('Иванов Иван, Петров Петр')
  end
end