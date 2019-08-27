class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action  :publish_comment, only: :create

  def create
    authorize! :create, Comment
    @commentable.comments << comment
    comment.user = current_user
    comment.save
  end

  private

  helper_method :comment

  def comment
    @comment ||= params[:id] ? Comment.find(params[:id]) : Comment.new(comment_params) 
  end

  def set_commentable
    if params[:question_id].present?
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id].present?
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    data = {
      commentable_id: comment.commentable_id,
      commentable_type: comment.commentable_type.underscore,
      comment: comment,
      comment_user_email: current_user.email
    }
    ActionCable.server.broadcast(
      "comments_for_#{@comment.commentable_type == 'Question' ? @commentable.id : @commentable.question_id}",
      data
    )
  end

end
