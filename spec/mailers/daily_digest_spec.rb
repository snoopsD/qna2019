require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:old_question) { create(:question, created_at: 1.day.ago, user: user) }
    let!(:new_question) { create(:question, title: 'New question', user: user) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Questions digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to have_content(new_question.title) 
      expect(mail.body.encoded).to_not have_content(old_question.title)
    end
  end
end
