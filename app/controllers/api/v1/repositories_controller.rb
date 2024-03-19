class Api::V1::RepositoriesController < ApplicationController
  def index
    github_service = GithubApiService.new(
      params[:search_term],
      params[:sort_by],
      params[:per_page],
      params[:page],
      params[:order]
    )
    repositories = github_service.fetch_repositories

    render json: repositories
  end
end
