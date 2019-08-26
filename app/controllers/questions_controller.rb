class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: %i[index show]  

  after_action :publish_question, only: [:create]
  
  authorize_resource  
  skip_authorization_check only: :index

  def index
    authorize! :read, Question
    @questions = Question.all
  end
  
  def new
    question.links.new
    question.build_badge
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
