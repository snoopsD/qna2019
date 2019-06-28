require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }
    
    context 'with valid attributes' do

      it 'saves a new answer in db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'created answer belongs to current_user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:answer).user).to eq user
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) } 
        expect(response).to redirect_to question
      end

    end

    context 'with invalid attributes' do

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template("questions/show")
      end

    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'author answer' do

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question
      end

    end

    context 'not author answer' do
      before { login(other_user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to_not change(Answer, :count)
      end

      it 're-render to answer' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question
      end
    end

  end

end
