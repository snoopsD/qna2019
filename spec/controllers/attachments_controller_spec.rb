require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    let!(:question) { create(:question, user: user, files: [file]) }
    let(:answer) { create(:answer, question: question, user: user, files: [file]) }

    context 'author answer' do
      it 'remove attachments to the resource' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js}.to change(answer.files.attachments, :count).by(-1)
      end

      it 'redirects to question', js: true do
        delete :destroy, params: { id: answer.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end 

    context 'not author answer' do
      before { login(other_user) }

      it 'remove attachments to the resource' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files.attachments, :count)
      end

      it 'redirects to question', js: true do
        delete :destroy, params: { id: answer.files.first }, format: :js
        expect(response).to render_template :destroy
      end

    end 
  end
end
