require 'rails_helper'

RSpec.describe Validation, type: :model do
  it 'should show invalid email address' do
    email = Validation.new.email("ahmad.com")
    expect(email).to eq(false)
  end

  it 'should show valid email address' do
    email = Validation.new.email("ahmad@kuyainside.com")
    expect(email).to eq(true)
  end

  it 'should able scan mentioned email' do
    emails = Validation.new.scan_email("This is just test for scan an@email.com")
    expect(emails.count).to eq(1)
    expect(emails.first).to eq("an@email.com")

    emails = Validation.new.scan_email("This is just test for scan an@email.com and another be@email.com")
    expect(emails.count).to eq(2)
    expect(emails.last).to eq("be@email.com")
  end
end
