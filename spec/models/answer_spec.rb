require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }

  describe 'Check best answer' do
    let(:user) { create(:user) }  
    let(:question) { create(:question, user: user) }
    let(:answer)   { create(:answer, question: question, user: user) }

    it 'set attribute best to true' do
      answer.check_best
      expect(answer).to be_best
    end

    it 'not to be best' do
      expect(answer).not_to be_best
    end

    context 'only one answer' do
      let!(:best_answer) { create(:answer, question: question, best: true) }

      before { answer.check_best }

      it { expect(best_answer.reload).to_not be_best }
      it { expect(answer.reload).to be_best }
    end

    it 'have many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end
end
