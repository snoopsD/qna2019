require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe 'GET #find' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    context 'with valid request' do

      before do 
        allow(Services::Searches).to receive(:find_query).and_return(question)
      end

      it 'assign result fo calling Services::Searches to @query_show' do
        get :find, params: { query: 'question', find_field: 'MyQuestion' }
        expect(assigns(:query_show)).to eq question
      end

      it 'render template' do
        get :find, params: { query: 'question', find_field: 'MyQuestion' }
        expect(response).to render_template "searches/_question"
      end
    end

    context 'with invalid request' do

      it 'redirects to root_path' do
        get :find, params: { query: 'question', find_field: '' }
        expect(response).to redirect_to root_path
      end

      it 'flash alert' do
        get :find, params: { query: 'question', find_field: '' }
        expect( subject.request.flash[:alert] ).to_not be_nil
      end
    end

  end
end
