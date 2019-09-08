class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize! :create, Subscription
    subscription.save  
  end

  def destroy
    authorize! :destroy, subscription   
    subscription.destroy
  end

  private

  helper_method :question

  def subscription
    Subscription.find_or_initialize_by(user: current_user, question: question) 
  end  

  def question
    Question.find_by(id: params[:question_id] || params[:id])
  end

end
