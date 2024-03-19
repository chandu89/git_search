class Api::V1::RepositoriesController < ApplicationController
  def index
    search_term = params[:search_term]
    sort_by = params[:sort_by].presence || 'stars' # default sort by stars
    per_page = params[:per_page].presence || 10
    page = params[:page].presence || 1
    order = params[:order].presence || "desc"

    response = HTTParty.get("#{GIT_REPO_URL}?q=#{search_term}&sort=#{sort_by}&order=#{order}&per_page=#{per_page}&page=#{page}")
    if response.success?
      render json: format_response(response), status: :ok
    else
      render json: { error: 'Failed to fetch repositories' }, status: :unprocessable_entity
    end
  end

  private

  def format_response(response)
    repositories = response['items'].map do |repo|
      {
        name: repo['name'],
        author: repo['owner']['login'],
        repository_url: repo['html_url'],
        stars: repo['stargazers_count']
      }
    end

    { repositories: repositories }
  end
end
