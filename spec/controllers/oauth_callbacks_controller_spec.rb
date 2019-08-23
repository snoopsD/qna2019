require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { OmniAuth::AuthHash.new({ 'provider' => 'github', 'uid' => '123' }) }
    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }
      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        user.confirm
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do        
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end
      it 'render add email' do  
        expect(response).to render_template("oauth_callbacks/add_mail")
      end 

      it 'does not login' do
        expect(subject.current_user).to_not be
      end
    end
 
  end

  describe 'Instagram' do
    let(:oauth_data) { OmniAuth::AuthHash.new({ 'provider' => 'instagram', 'uid' => '123' }) }
    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :instagram
    end

    context 'user exists' do
      let!(:user) { create(:user) }
      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        user.confirm
        get :instagram
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do        
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :instagram
      end
      it 'render add email' do  
        expect(response).to render_template("oauth_callbacks/add_mail")
      end 

      it 'does not login' do
        expect(subject.current_user).to_not be
      end
    end
 
  end
end
