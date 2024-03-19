class Api::V1::RepositoriesController < ApplicationController
  def index
    search_term = params[:search_term]
    sort_by = params[:sort_by].presence || 'stars' # default sort by stars
    per_page = params[:per_page].presence || 10
    page = params[:page].presence || 1
    order = params[:order].presence || 'desc' # default order is descending
    
    uri = URI("#{GIT_REPO_URL}?q=#{search_term}&sort=#{sort_by}&order=#{order}&per_page=#{per_page}&page=#{page}")
    response = Net::HTTP.get(uri)
    repositories = parse_response(response)

    render json: repositories
  end

  private

  def parse_response(response)
    parsed_response = JSON.parse(response)
    repositories = parsed_response['items'].map do |item|
      {
        name: item['name'],
        author: item['owner']['login'],
        repository_url: item['html_url'],
        stars: item['stargazers_count']
      }
    end
    repositories
  end
end
