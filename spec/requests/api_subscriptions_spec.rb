require 'spec_helper'

describe "Subscriptions" do
  describe "GET /subscriptions" do
    let(:user) { FactoryGirl.create(:user, email: "kitty@cat.com") }
    let!(:subscription) { FactoryGirl.create(:subscription, user: user) }
    let(:credentials){ActionController::HttpAuthentication::Token.encode_credentials('TEST')}
    let(:headers) do
      {
       "Authorization" => credentials,
       "Accept" => "application/json"     # This is what Rails 4 accepts
       # "http_accept" => "application/json", # This is what Rails 3 accepts
      }
    end
    context 'with proper token' do
      it "succeeds" do
        get api_subscriptions_path, nil, headers
        expect(response).to be_success
        expect(JSON.parse(response.body)).to include(a_hash_including("email"  => "kitty@cat.com"))
      end
    end
    context 'without proper token' do
      let(:credentials){ActionController::HttpAuthentication::Token.encode_credentials('wrongtoken')}
      it "fails" do
        get api_subscriptions_path, nil, headers
        expect(response).not_to be_success
      end
    end
  end
end
