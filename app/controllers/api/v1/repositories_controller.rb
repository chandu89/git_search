class Api::V1::RepositoriesController < ApplicationController
  def index
    search_term = params[:search_term]
    sort_by = params[:sort_by].presence || 'stars' # default sort by stars
    per_page =1 
    page = params[:page].presence || 1
    
    response = HTTParty.get("#{GIT_REPO_URL}?q=#{search_term}&sort=#{sort_by}&per_page=#{per_page}&page=#{page}")

    if response.success?
      render json: response.body, status: :ok
    else
      render json: { error: 'Failed to fetch repositories' }, status: :unprocessable_entity
    end
  end
end
