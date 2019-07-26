class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]  

  def index
    @questions = Question.all
  end
  
  def new
    question.links.new
  end

  def show
    @answer = question.answers.new
    @answer.links.new
  end  

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end  
  end

  def update
    question.update(question_params) if current_user.author?(question)
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      redirect_to questions_path, notice: "Question successfully delete"
    else
      redirect_to question, notice: 'You are not the author question.'
    end
  end

  def remove_attachments
    if current_user.author?(question)
      question.files.find(params[:file]).purge
      redirect_to question
    end  
  end

  private
  
  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url,  :_destroy], :image)
  end

end
