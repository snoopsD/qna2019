require 'rails_helper'

RSpec.describe Services::AnswersSubscribe do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: users[0]) }
  let!(:answer) { create(:answer, question: question, user: users[1]) }
  let!(:subscription) { create(:subscription, question: question, user: users[1]) }
      
  it 'sends answer to all subscribed users' do
    question.subscriptions.each do |sub|
      expect(AnswersMailer).to receive(:notify_subscribers).with(sub).and_call_original
    end  
    subject.send_subscribe(answer)
  end

  it 'not sends answer to not subscribed users' do
    expect { subject.send_subscribe(answer) }.to_not change(ActionMailer::Base.deliveries, :count)
  end
end
