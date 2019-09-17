class SearchesController < ApplicationController
  skip_authorization_check

  def find   
    if search_params[:find_field] != ""
      @query_show = Services::Searches.find_query(search_params[:query], search_params[:find_field])
      render "_#{search_params[:query].underscore}"
    else
      redirect_to root_path, alert: 'Empty query'
    end 
  end

  private 

  def search_params
    params.permit(:query, :find_field)
  end
end
