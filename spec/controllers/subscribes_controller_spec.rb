require 'rails_helper'

RSpec.describe SubscribesController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }  

  describe 'POST #create' do
    context 'with authenticated user' do
      before { login(user) }

      it 'add subscribe' do
        expect { post :create, params: { question_id: question, user_id: user }, format: :js }.to change(user.subscribes, :count).by(1)
      end

      it 'render subsribe' do
        post :create, params: { question_id: question }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with unauthenticated user' do
      it "can't add subscribe" do
        expect { post :create, params: { question_id: question }, format: :js }.to_not change(Subscribe, :count)
      end

      it '401 status' do
        post :create, params: { question_id: question }, format: :js

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscribe) { create(:subscribe, user: user, question: question) }

    context 'with authenticated user' do
      before { login(user) }

      it 'remove subscribe' do
        expect { delete :destroy, params: { question_id: question, id: subscribe }, format: :js }.to change(user.subscribes, :count).by(-1)
      end

      it 'render subscribe' do
        delete :destroy, params: { question_id: question, id: subscribe }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'with unauthenticated user' do
      it "can't remove subscribe" do
        expect { delete :destroy, params: { question_id: question, id: subscribe }, format: :js }.to_not change(Subscribe, :count)
      end

      it '401 status' do
        delete :destroy, params: { question_id: question, id: subscribe }, format: :js

        expect(response).to have_http_status(401)
      end
    end
  end
end
