require 'rails_helper'

RSpec.describe 'home/index.html.slim', type: :view do

  it 'now contain nothing' do
    render
    expect(rendered).to match ''
  end

end
