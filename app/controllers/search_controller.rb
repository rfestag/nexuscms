class SearchController < ApplicationController
  def search
    render json: Searchable.search(params[:query])
  end
end
