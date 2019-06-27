require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }

  describe 'author of question/answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    it 'check user id who created question/answer with current_user' do
      expect(question.user.id).to eq user.id
      expect(answer.user.id).to eq user.id
    end
  end
end
