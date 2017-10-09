class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  validates_uniqueness_of :user_id, scope: :friend_id

  def self.connect(emails)
    return {message: 'Required 2 emails', success: false} if emails.length != 2
    users = []
    emails.each do |email|
      begin
        users << User.init(email)
      rescue => e
        return {message: e.to_s, success: false}
      end
    end

    if User.friendship?(users)
      return {message: "Already connected", success: false}
    else
      User.connecting(users)
      return {success: true}
    end
  end

  def self.list(email)
    return {message: "#{email} is invalid email", success: false} unless Validation.new.email(email)
    user = User.find_by_email(email)
    if user.present?
      friends = user.friends.map(&:email)
      count = friends.count
      return {success: true, friends: friends, count: count}
    else
      return {message: "#{email} is not exist", success: false}
    end
  end

  def self.common(emails)
    return {message: 'Required 2 emails', success: false} if emails.length != 2

    users = []
    emails.each do |email|
      begin
        users << User.init(email)
      rescue => e
        return {message: e.to_s, success: false}
      end
    end

    a = users.first.friends
    b = users.last.friends
    commons = a.select{|x| b.include?(x)}.map(&:email) || []
    return {success: true, friends: commons, count: commons.count}
  end
end
