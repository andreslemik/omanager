require 'rails_helper'

RSpec.describe Instalment, type: :model do
  it 'create 6 instalments' do
    expect {
      create_list :instalment, 6
    }.to change(Instalment, :count).by 6
  end
end
