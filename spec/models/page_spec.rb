require 'rails_helper'

RSpec.describe Page, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:page).save).to be true
  end
  it 'is invalid without url' do
    expect(FactoryGirl.build(:page, url: nil).save).to be false
  end
  it 'is invalid without parsed data' do
    expect(FactoryGirl.build(:page, parsed: nil).save).to be false
  end
  it 'is invalid without a chksum' do
    expect(FactoryGirl.build(:page, chksum: nil).save).to be false
  end
end
