class Services::AnswersSubscribe

  def send_subscribe(answer)
    answer.question.subscribes.find_each(batch_size: 500) do |subscribe|
      AnswersMailer.notify_subscribers(subscribe).deliver_later
    end
  end

end
