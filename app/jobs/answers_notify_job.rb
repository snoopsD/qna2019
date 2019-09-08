class AnswersNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::AnswersSubscribe.new.send_subscribe(answer) 
  end

end
