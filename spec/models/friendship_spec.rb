require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it 'should connect between two users' do
    a = "a@test.com"
    b = "b@test.com"
    c = "c@test.com"
    d = "faileemail.com"

    connect = Friendship.connect([a, b])
    expect(connect).to eql({success: true})

    connect = Friendship.connect([a, b, c])
    expect(connect).to eql({message: "Required 2 emails", success: false})

    connect = Friendship.connect([a, d])
    expect(connect).to eql({message: "Validation failed: Email is invalid", success: false})

    connect = Friendship.connect([a, b])
    expect(connect).to eql({message: "Already connected", success: false})
  end

  it 'should show list of friends' do
    a = "a@test.com"
    b = "b@test.com"
    c = "c@test.com"
    d = "another@email.com"

    Friendship.connect([a, b])
    Friendship.connect([a, c])

    friends = Friendship.list(a)
    expect(friends).to eql({friends: [b, c], success: true, count: 2})

    friends = Friendship.list(d)
    expect(friends).to eql({message: "#{d} is not exist", success: false})
  end

  it 'should show common friends' do
    a = "a@test.com"
    b = "b@test.com"
    c = "c@test.com"
    d = "another@email.com"
    e = "failur_email.com"

    Friendship.connect([a, b])
    Friendship.connect([a, c])
    Friendship.connect([b, c])

    friends = Friendship.common([a, b])
    expect(friends).to eql({success: true, friends: [c], count: 1})

    friends = Friendship.common([b, c])
    expect(friends).to eql({success: true, friends: [a], count: 1})

    friends = Friendship.common([a, c])
    expect(friends).to eql({success: true, friends: [b], count: 1})

    friends = Friendship.common([b, d])
    expect(friends).to eql({success: true, friends: [], count: 0})

    friends = Friendship.common([a, e])
    expect(friends).to eql({message: "Validation failed: Email is invalid", :success=>false})
  end
end
