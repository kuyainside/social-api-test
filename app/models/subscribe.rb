class Subscribe < ApplicationRecord
  belongs_to :user
  belongs_to :subscriber, :class_name => 'User'

  validates_uniqueness_of :user_id, :scope => :subscriber_id, message: "Already subscribe"
  validates :subscriber_id, presence: true

  def self.connecting(users)
    users.first.subscribes.create(subscriber_id: users.last.id)
    users.last.subscribes.create(subscriber_id: users.first.id)
  end

  def self.store(requestor, target)
    users = []
    [requestor, target].each do |email|
      begin
        users << User.find_or_create_by!(email: email)
      rescue => e
        return {message: e.to_s, success: false}
      end
    end

    begin
      Subscribe.create_subscribe(users)
      return {success: true}
    rescue => e
      return {message: e.to_s, success: false}
    end
  end

  def self.create_subscribe(users)
    #first = requestor
    #last = target
    users.last.subscribes.create!(subscriber_id: users.first.id)
  end

  def self.block(requestor, target)
    [requestor, target].each do |email|
      return {message: "#{email} is invalid email", success: false} unless Validation.new.email(email)
    end
    action = Subscribe.init_block(requestor, target)
    action[:req].subscribes.find_by_subscriber_id(action[:user_target].id).update_attribute(:block, true)
    return {success: true}
  end

  def self.unblock(requestor, target)
    [requestor, target].each do |email|
      return {message: "#{email} is invalid email", success: false} unless Validation.new.email(email)
    end
    action = Subscribe.init_block(requestor, target)
    action[:req].subscribes.find_by_subscriber_id(action[:user_target].id).update_attribute(:block, false)
    return {success: true}
  end

  def self.init_block(requestor, target)
    users = []
    [requestor, target].each do |email|
      user = User.find_by(email: email)
      users << user
      return {message: "#{email} can't be blank or email is not exist", success: false} unless user.present?
    end

    user_target = User.find_by_email(target)
    req = User.find_by_email(requestor)
    return {user_target: user_target, req: req}
  end

  def self.send_email(sender, text)
    return {message: "#{email} is invalid email", success: false} unless Validation.new.email(email)
    user = User.find_by_email(sender)
    return {message: "User not found", success: false} if user.blank?
    Subscribe.scan_email(sender, text)
    friend_ids = user.friends.map(&:friend_id)
    block_ids = user.subscribes.where(block: true).map(&:subscriber_id)
    non_block_ids = user.subscribes.where(block: false).map(&:subscriber_id)
    recipients = (friend_ids + non_block_ids).select{|x| block_ids.exclude?(x)}.uniq || []
    return {success: true, recipients: User.find(recipients).map(&:email)}
  end

  def self.scan_email(user, text)
    emails = []
    Validation.new.scan_email(text){ |x| emails << x }
    emails.each do |email|
      Subscribe.create_subscribe(email, user)
    end
  end
end
