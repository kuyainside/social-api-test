require 'rails_helper'

RSpec.describe Api::FriendsController, type: :controller do

  describe 'GET /api/friends' do
    let(:valid_attribute) { { email: 'a@test.com'} }

    before {
      Friendship.connect(['a@test.com', 'b@test.com'])
    }

    context 'when request attributes are valid' do
      it 'returns success' do
        get "index", params: valid_attribute
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, friends: ['b@test.com'], count: 1}.to_json)
      end
    end
  end

  describe 'POST /api/friends' do
    let(:valid_attributes) { { friends: ['a@test.com', 'b@test.com']} }
    let(:invalid_attributes) { { friends: ['a@test.com', 'btest.com']} }
    let(:wrong_input_attributes) { { friends: ['a@test.com']} }

    context 'when request attributes are valid' do
      it 'returns success' do
        post "create", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true}.to_json)

        post "create", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Already connected", success: false}.to_json)
      end
    end

    context 'when request attributes are invalid' do
      it 'returns invalid email' do
        post "create", params: invalid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Validation failed: Email is invalid", success: false}.to_json)
      end
    end

    context 'when request attributes are wrong' do
      it 'returns invalid input array' do
        post "create", params: wrong_input_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Required 2 emails", success: false}.to_json)
      end
    end
  end

  describe 'POST /api/friends/common' do
    before {
      Friendship.connect(['a@test.com', 'b@test.com'])
      Friendship.connect(['a@test.com', 'c@test.com'])
      Friendship.connect(['a@test.com', 'd@test.com'])
      Friendship.connect(['d@test.com', 'b@test.com'])
    }

    context 'when request by 2 emails' do
      it 'returns success' do
        post "common", params: {friends: ['a@test.com', 'b@test.com']}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, friends: ['d@test.com'], count: 1}.to_json)
      end

      it 'returns empty common friends' do
        post "common", params: {friends: ['a@test.com', 'c@test.com']}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, friends: [], count: 0}.to_json)
      end
    end
  end

end
