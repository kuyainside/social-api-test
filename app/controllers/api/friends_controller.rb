class Api::FriendsController < ApplicationController

  api :get, '/friends', 'List of friends'
  param :email, String, required: true, desc: 'email current user'
  def index
    friends = Friendship.list(params[:email])
    render json: friends
  end

  api :post, '/friends', 'Create friends'
  param :friends, Array, required: true, desc: 'connected emails'
  def create
    connect = Friendship.connect(params[:friends])
    render json: connect
  end

  api :post, '/friends/common', 'Common friends'
  param :friends, Array, required: true, desc: 'requestor and receiver friends email'
  def common
    common_friends = Friendship.common(params[:friends])
    render json: common_friends
  end
end
