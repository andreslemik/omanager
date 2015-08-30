require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'not valid without name' do
    category = build :category, name: nil
    expect(category).to_not be_valid
  end
end
