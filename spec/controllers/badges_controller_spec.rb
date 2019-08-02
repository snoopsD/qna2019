require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:badges_list) { create_list(:badge, 2, question: question, answer: answer) }
  
  context 'user who have badges' do
    describe 'GET #index' do
      before { login(user) }
      
      before { get :index, params: { user_id: user.id} }

      it 'populates an badges' do
        expect(assigns(:badges)).to eq badges_list
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
  end

  context 'user havent rewards' do
    before {login(other_user)}

    before { get :index, params: { user_id: other_user.id} }

    it 'does not assign badges' do
      expect(assigns(:badges)).to_not eq badges_list
    end

  end
end
