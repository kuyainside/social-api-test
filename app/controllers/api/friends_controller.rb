class Api::FriendsController < ApplicationController

  api :get, '/friends', 'List of friends'
  param :email, String, required: true, desc: 'Selected user email'
  def index
    friends = Friendship.list(params[:email])
    render json: friends
  end

  api :post, '/friends', 'Connecting friends'
  param :friends, Array, required: true, desc: 'It must be not more than or less than 2 emails'
  def create
    connect = Friendship.connect(params[:friends])
    render json: connect
  end

  api :post, '/friends/common', 'Common friends'
  param :friends, Array, required: true, desc: 'It must be not more than or less than 2 emails. To get mutual friends between those emails'
  def common
    common_friends = Friendship.common(params[:friends])
    render json: common_friends
  end
end
