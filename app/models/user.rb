class User < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  has_many :subscribes
  has_many :subscribers, :through => :subscribes
  
  has_many :inverse_subscribes, :class_name => "Subscribe", :foreign_key => "subscriber_id"
  has_many :inverse_subscribers, :through => :inverse_subscribes, :source => :user

  has_many :friendships
  has_many :friends, :through => :friendships
  
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  def self.init(email)
    self.find_or_create_by!(email: email)
  end

  def self.friendship?(users)
    a = users.first
    b = users.last
    a.is_connected?(b)
  end

  def self.connecting(users)
    users.first.friendships.create(friend_id: users.last.id)
    users.last.friendships.create(friend_id: users.first.id)
    Subscribe.connecting(users)
  end

  def is_connected?(target)
    friends.include?(target)
  end

  def has_subscriber?(user)
    self.subscribers.include?(user)
  end
end
