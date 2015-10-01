require 'rails_helper'

RSpec.describe Instalment, type: :model do
  it 'create 6 instalments' do
    expect do
      create_list :instalment, 6
    end.to change(Instalment, :count).by 6
  end

  it 'two instalments by 5000 summary' do
    create_list :instalment, 2, amount: 5000
    expect(Instalment.summary).to eq(10_000)
  end

  it 'two of three instalments after 01.01.2016' do
    (0..2).each do |i|
      FactoryGirl.create :instalment,
                         payment_date: Date.parse('05.12.2015') + i.months
    end
    expect(Instalment.after_date('01.01.2016').count).to eq(2)
  end
end
