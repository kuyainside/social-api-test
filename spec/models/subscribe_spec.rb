require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it 'should subscribe an email' do
    a = "a@test.com"
    b = "b@test.com"
    c = "failsedemail.com"
    status = Subscribe.store(a, b)
    expect(status).to eq({success: true})
    user = User.find_by_email(b)
    expect(user.subscribers.count).to eq(1)

    status = Subscribe.store(a, c)
    expect(status).to eq({message: "Validation failed: Email is invalid", success: false})
  end

  it "should block and unblock an email from updates" do
    a = "a@test.com"
    b = "b@test.com"
    c = "c@test.com"
    d = "failsedemail.com"

    Subscribe.store(a, b)
    user_a = User.find_by_email(a)
    user_b = User.find_by_email(b)

    status = user_b.subscribes.find_by(subscriber_id: user_a.id).block
    expect(status).to eq(false)

    #block
    Subscribe.block(b, a)
    status = user_b.subscribes.find_by(subscriber_id: user_a.id).block
    expect(status).to eq(true)

    #unblock
    Subscribe.unblock(b, a)
    status = user_b.subscribes.find_by(subscriber_id: user_a.id).block
    expect(status).to eq(false)
  end

  it "should retrieve all email addresses that can receive updates from an
email address" do
    a = "a@test.com"
    b = "b@test.com"
    c = "c@test.com"
    d = "d@test.com"
    z = "failedemail.com"

    #failed
    status = Subscribe.send_email(a, "Hellow world")
    expect(status).to eq({message: "User not found", success: false})

    Friendship.connect([a, b])
    Subscribe.store(d, a)

    #retrieve emails
    status = Subscribe.send_email(a, "Hellow world")
    expect(status).to eq(success: true, recipients: [b, d])

    #invalid email
    status = Subscribe.send_email(z, "Hellow world")
    expect(status).to eq(message: "#{z} is invalid email", success: false)

    #invite email mentioned
    status = Subscribe.send_email(b, "We need to invite d@test.com")
    expect(status).to eq({success: true, recipients: [a, d]})

    #block 1 user
    Subscribe.block(a, b)
    status = Subscribe.send_email(a, "We need to invite d@test.com c@test.com")
    expect(status).to eq({success: true, recipients: [d, c]})

    #unblock 1 user
    Subscribe.unblock(a, b)
    status = Subscribe.send_email(a, "We need to invite d@test.com c@test.com")
    expect(status).to eq({success: true, recipients: [b, d, c]})
  end
end
