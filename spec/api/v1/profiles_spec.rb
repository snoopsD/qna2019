require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:user) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do 
      let(:method) { :get }      
    end  

    context 'authorized' do

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do        
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[admin].each do |attr|
          expect(json[attr]).to eq user.send(attr).as_json
        end        
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end        
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let!(:users) { create_list(:user, 4) }

    context 'authorized' do

    before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it 'returns all users exclude login user ' do
        expect(json['users'].size).to eq 4
      end

      it 'returns all public fields' do
        %w[admin].each do |attr|
          expect(json[attr]).to eq user.send(attr).as_json
        end        
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end        
      end
    end

  end
end
