class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!

  after_action :publish_answer, only: [:create]

  def create  
    authorize! :create, answer
    @answer = question.answers.new(answer_params)
    @answer.user = current_user    
    flash[:notice] = 'Your answer successfully created.' if @answer.save
  end

  def update
    authorize! :update, answer
    answer.update(answer_params)
    @question = answer.question
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
    flash[:notice] = "Answer successfully delete"
  end

  def best
    authorize! :best, answer
    answer.check_best 
  end

  private

  def publish_answer
    return if answer.errors.any?

    data = {
      answer: answer,
      answer_user_id:     current_user.id,
      answer_rate:        answer.rate,
      links: answer.links,
      files: answer.files.map { |file| { id: file.id, name: file.filename.to_s, url: url_for(file) } },
      question_user_id:   question.user_id,      
    }

    ActionCable.server.broadcast("question_#{params[:question_id]}", data)
  end

  def question
    @question ||= Question.find(params[:question_id]) 
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url,  :_destroy])
  end  

end
