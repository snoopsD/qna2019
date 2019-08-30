class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    authorize! :destroy, attachment
    attachment.purge 
  end

  private 

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :attachment
end
