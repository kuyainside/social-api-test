require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it 'email with invalid format is invalid' do
    user = User.new(email: 'bugs')
    user.save
    expect(user.errors.messages[:email]).to eq(['is invalid'])
  end
  it { should have_many(:friendships) }
  it 'should create an email' do
    a = User.init("test@test.com")
    expect(User.count).to eq(1)
    expect(a.email).to eq("test@test.com")
  end

  it 'should show their friendship status is false' do
    a = User.init("a@test.com")
    b = User.init("b@test.com")
    status = User.friendship?([a, b])
    expect(status).to eq(false)
  end

  it 'should show their friendship status is true' do
    a = User.init("a@test.com")
    b = User.init("b@test.com")
    status = User.friendship?([a, b])
    expect(status).to eq(false)

    connect = User.connecting([a, b])
    status = User.friendship?([a, b])
    expect(status).to eq(true)
  end

  it 'should show their subscribe status is false' do
    a = User.init("a@test.com")
    b = User.init("b@test.com")
    status = a.has_subscriber?(b)
    expect(status).to eq(false)
  end

  it 'should show their subscribe status is true' do
    a = User.init("a@test.com")
    b = User.init("b@test.com")
    Subscribe.create_subscribe([b, a])
    status = a.has_subscriber?(b)
    expect(status).to eq(true)
  end
end
