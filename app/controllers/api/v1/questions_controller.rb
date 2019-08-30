class Api::V1::QuestionsController < Api::V1::BaseController 
 
  def index
    authorize! :read, current_resource_owner
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    authorize! :read, question    
    render json: question
  end

  def create
    authorize! :create, Question
    @question = current_resource_owner.questions.new(question_params)
    @question.save ? head(201) : head(422)
  end

  def update
    authorize! :update, question
    question.update(question_params) ? head(:ok) : head(422)
  end

  def destroy
    authorize! :destroy, question
    question.destroy
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end


  def question_params
    params.require(:question).permit(:title, :body)
  end

end
