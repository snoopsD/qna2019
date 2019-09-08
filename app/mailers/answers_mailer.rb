class AnswersMailer < ApplicationMailer

  def notify_subscribers(subscription)
    @subscription = subscription

    mail to: subscription.user.email
  end
end
