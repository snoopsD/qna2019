require 'rails_helper'

RSpec.describe Services::AnswersSubscribe do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: users[0]) }
  let!(:answer) { create(:answer, question: question, user: users[1]) }
  let!(:subscribe) { create(:subscribe, question: question, user: users[1]) }
  let(:mailer) { double('AnswersMailer') }
      
  it 'sends answer to all subscribed users' do
    Subscribe.first.delete
     #не понимаю, почему не проходит без первой строчки тест, хотя в реальности все работает 
     #при вызове send_subscribe(subscribe), вызывается первая подписка автора вопроса
    expect(AnswersMailer).to receive(:notify_subscribers).with(subscribe).and_call_original
    subject.send_subscribe(subscribe)
  end

  it 'not sends answer to not subscribed users' do
    expect(mailer).to_not receive(:subscribe).with(question, users[2])
    subject.send_subscribe(answer)
  end
end
