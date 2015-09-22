require 'rails_helper'

RSpec.describe Account, type: :model do
  it 'create one account item' do
    expect {
      create :account, :partner_operation
    }.to change(Account, :count).by 1
  end
end
