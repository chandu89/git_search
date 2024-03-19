# spec/controllers/api/v1/repositories_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::RepositoriesController, type: :controller do
  describe 'GET #index' do
    let(:search_term) { 'rails' }
    let(:per_page) { 10 }
    let(:page) { 1 }
    context 'when the request is successful' do
      let(:success_response) do
        {
          'items' => [
            { 'name' => 'git_search', 'owner' => { 'login' => 'chandan' }, 'html_url' => 'https://github.com/rails/rails', 'stargazers_count' => 100 }
          ]
        }
      end
      before do
        allow(HTTParty).to receive(:get).and_return(double(success?: true, body: success_response.to_json))
        get :index, params: { search_term: search_term, per_page: per_page, page: page }
      end
      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns JSON with repositories' do
        get :index, params: { search_term: search_term, per_page: per_page, page: page }
        json_response = JSON.parse(response.body)
        expect(json_response['items']).not_to be_empty
      end
    end
  end
end
