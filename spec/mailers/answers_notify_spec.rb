require "rails_helper"

RSpec.describe AnswersMailer, type: :mailer do
  describe "notify_subscribers" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:subscribe) { create(:subscribe, question: question, user: other_user)  }
    let(:mail) { AnswersMailer.notify_subscribers(subscribe) }

    it "renders the headers" do
      expect(mail.to).to eq([subscribe.user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to have_content(question.title) 
      expect(mail.body.encoded).to have_content('Question has a new answer')
    end
  end
end
