class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create  
    @answer = question.answers.new(answer_params)
    @answer.user = current_user    
    flash[:notice] = 'Your answer successfully created.' if @answer.save
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
    @question = answer.question
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      flash[:notice] = "Answer successfully delete"
    end
  end

  def best
    answer.check_best if current_user.author?(answer)      
  end

  def remove_attachments
    if current_user.author?(answer)
      answer.files.find(params[:file]).purge
      redirect_to question_path(answer.question)
    end  
  end

  private

  def question
    @question = Question.find(params[:question_id]) 
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end  

end
