require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it 'email with invalid format is invalid' do
    user = User.new(email: 'bugs')
    user.save
    expect(user.errors.messages[:email]).to eq(['is invalid'])
  end
  it { should have_many(:friends) }
end
