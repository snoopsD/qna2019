module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:voteup, :votedown]    
  end  

  def voteup
    authorize! :voteup, @votable
    respond(@votable.voteup(current_user))
  end  

  def votedown
    authorize! :voteup, @votable
    respond(@votable.votedown(current_user))
  end 

  private

  def model_klass
    controller_name.classify.constantize
  end  

  def set_votable
    @votable = model_klass.find(params[:id])
  end 

  def respond(result)
    if result.errors.any?
      render json: result.errors.full_messages, status: 422
    else
      render json: @votable.rate, status: :ok
    end
  end
end   
