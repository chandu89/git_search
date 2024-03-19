# spec/controllers/api/v1/repositories_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::RepositoriesController, type: :controller do
  describe 'GET #index' do
    let(:search_term) { 'rails' }
    let(:per_page) { 10 }
    let(:page) { 1 }

    before do
      allow(HTTParty).to receive(:get).and_return(success_response)
    end

    context 'when the request is successful' do
      let(:success_response) do
        {}
      end

      it 'returns a successful response' do
        get :index, params: { search_term: search_term, per_page: per_page, page: page }
        expect(response).to have_http_status(:ok)
      end

      it 'returns JSON with repositories' do
        get :index, params: { search_term: search_term, per_page: per_page, page: page }
        expect(response['repositories']).not_to be_empty
      end
    end
  end
end
