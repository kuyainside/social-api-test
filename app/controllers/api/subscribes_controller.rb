class Api::SubscribesController < ApplicationController

  api :post, '/subscribes', 'Create a subscribe'
  param :requestor, String, required: true, desc: 'Requestor email for subscribe'
  param :target, String, required: true, desc: 'Target email get new subscriber'
  def create
    subscribe = Subscribe.store(params[:requestor], params[:target])
    render json: subscribe
  end

  api :post, '/subscribes/block', 'Block subscriber'
  param :requestor, String, required: true, desc: 'Requestor email'
  param :target, String, required: true, desc: 'Target email to block'
  def block
    block = Subscribe.block(params[:requestor], params[:target])
    render json: block
  end

  api :post, '/subscribes/unblock', 'Unblock subscriber'
  param :requestor, String, required: true, desc: 'Requestor email'
  param :target, String, required: true, desc: 'Target email'
  def unblock
    block = Subscribe.unblock(params[:requestor], params[:target])
    render json: block
  end

  api :post, '/subscribes/send_email', 'Send email subscriber'
  param :sender, String, required: true, desc: 'Sender email'
  param :text, String, required: true, desc: 'Content'
  def send_email
    send_email = Subscribe.send_email(params[:sender], params[:text])
    render json: send_email
  end
end
