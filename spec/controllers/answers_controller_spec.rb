require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }
    
    context 'with valid attributes' do

      it 'saves a new answer in db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'created answer belongs to current_user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer).user).to eq user
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js 
        expect(response).to render_template :create
      end

    end

    context 'with invalid attributes' do

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end

    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'author answer' do

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { question_id: question, id: answer }, format: :js
        expect(response).to render_template :destroy
      end

    end

    context 'not author answer' do
      before { login(other_user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to_not change(Answer, :count), format: :js
      end

      it 're-render to answer' do
        delete :destroy, params: { question_id: question, id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do

      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do

      it 'does not changes answer attributes' do
        expect do
          patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #best' do
    before { login(user) }
    let(:answer) { create(:answer, question: question, user: user) }
    
    it 'choose answer to be best' do
      patch :best, params: { question_id: question, id: answer }, format: :js
      answer.reload
      expect(answer).to be_best
    end

    it 'render update template' do
      patch :best, params: { question_id: question, id: answer, answer: attributes_for(:answer) }, format: :js
      expect(response).to render_template :best
    end
  end

end
