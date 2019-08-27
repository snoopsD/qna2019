class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: %i[index show]  

  after_action :publish_question, only: [:create]
  
 
  def index
    authorize! :read, Question
    @questions = Question.all
  end
  
  def new
    authorize! :create, Question
    question.links.new
    question.build_badge
  end

  def show
    authorize! :read, question
    @answer = question.answers.new
    @answer.links.new
  end  

  def create
    authorize! :create, Question
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end  
  end

  def update
    authorize! :update, question
    question.update(question_params)
  end

  def destroy
    authorize! :destroy, question
    question.destroy
    redirect_to questions_path, notice: "Question successfully delete"
  end

  def remove_attachments
    if current_user.author?(question)
      question.files.find(params[:file]).purge
      redirect_to question
    end  
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/single_question', locals: { question: @question }
      )
    )
  end
  
  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url,  :_destroy], badge_attributes: [:name, :image])
  end

end
