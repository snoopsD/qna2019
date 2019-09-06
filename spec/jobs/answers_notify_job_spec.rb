require 'rails_helper'

RSpec.describe AnswersNotifyJob, type: :job do
  let(:service) { double('Services::AnswersSubscribe') }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  before do
    allow(Services::AnswersSubscribe).to receive(:new).and_return(service)
  end

  it 'calls Services::AnswersSubscribe#send_subscribe' do
    expect(service).to receive(:send_subscribe)
    AnswersNotifyJob.perform_now(answer)
  end
end
