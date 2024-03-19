require 'rails_helper'
require 'benchmark'

RSpec.describe Api::V1::RepositoriesController, type: :controller do
  describe "GET /index" do
    context "when valid parameters" do
      let(:search_term) { "rails" }
      let(:per_page) { 10 }
      let(:page) { 1 }

      let(:repositories) do
        [
          { "name" => "Repo1", "author" => "Author1", "repository_url" => "http://example.com/repo1", "stars" => 100 },
          { "name" => "Repo2", "author" => "Author2", "repository_url" => "http://example.com/repo2", "stars" => 200 }
          
        ]
      end
    
      before do
        allow_any_instance_of(GithubApiService).to receive(:fetch_repositories).and_return(repositories)
        get :index, params: { search_term: search_term, per_page: per_page, page: page }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns repositories based on the parameters" do
        expect(JSON.parse(response.body)).to eq(repositories)
      end
    end

    context "when invalid parameters" do
      let(:search_term) { "" }
      let(:per_page) { 0 }
      let(:page) { 0 }

      let(:repositories) do
        {
            "message" => "Validation Failed",
            "errors" => [
                {
                    "resource" => "Search",
                    "field" => "q",
                    "code" => "missing"
                }
            ],
            "documentation_url" => "https://docs.github.com/v3/search"
        }
      end
    
      before do
        # disabling it for actual error message
        # allow_any_instance_of(GithubApiService).to receive(:fetch_repositories).and_return(repositories)
        get :index, params: { search_term: search_term, per_page: per_page, page: page }
      end

      it "returns response error message json" do
        expect(JSON.parse(response.body)).to eq(repositories)
      end
    end


    context "when valid parameters and expecting actual result" do
      let(:search_term) { "rails" }
      let(:per_page) { 10 }
      let(:page) { 1 }
    
      before do
        get :index, params: { search_term: search_term, per_page: per_page, page: page }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns repositories based on the parameters" do
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end

  end
end
