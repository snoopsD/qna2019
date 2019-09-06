class SubscribesController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize! :create, Subscribe
    subscribe.save  
  end

  def destroy
    authorize! :destroy, subscribe
    
    subscribe.destroy
  end

  private

  helper_method :question

  def subscribe
    if @subscribe ||= params[:id] 
      subscribe_id = Subscribe.find_by(question_id: question.id).id
      Subscribe.find_by(id: subscribe_id , user_id: current_user.id) 
    else
      Subscribe.new(user_id: current_user.id, question_id: question.id)
    end  
  end  

  def question
    Question.find_by(id: params[:question_id]) || Question.find_by(id: params[:id])
  end

end
