class Services::AnswersSubscribe

  def send_subscribe(answer)
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      AnswersMailer.notify_subscribers(subscription).deliver_later
    end
  end

end
