class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create  
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(question), notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      redirect_to answer.question, notice: "Answer successfully delete"
    else
      redirect_to answer.question, notice: 'You are not the author answer.'
    end
  end

  private

  def question
    @question = Question.find(params[:question_id]) 
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body)
  end  

end
