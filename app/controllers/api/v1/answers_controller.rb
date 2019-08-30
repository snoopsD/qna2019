class Api::V1::AnswersController < Api::V1::BaseController 
 
  def index
    authorize! :index, current_resource_owner
    @answers = Answer.all
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    authorize! :read, answer
    render json: answer   
  end

  def create
    authorize! :create, Answer
    @answer = question.answers.new(answer_params)
    @answer.user = current_resource_owner    
    answer.save ? head(:ok) : head(422)
  end

  def update
    authorize! :update, answer
    answer.update(answer_params) ? head(:ok) : head(422)
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
  end

  private

  def question
    @question ||= Question.find(params[:question_id]) 
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url,  :_destroy])
  end  

end
