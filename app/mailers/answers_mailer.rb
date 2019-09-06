class AnswersMailer < ApplicationMailer

  def notify_subscribers(subscribe)
    @subscribe = subscribe

    mail to: subscribe.user.email
  end
end
