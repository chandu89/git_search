# spec/controllers/api/v1/repositories_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::RepositoriesController, type: :controller, vcr: { cassette_name: 'index_success' } do
  describe 'GET #index' do
    let(:search_term) { 'git_search' }
    let(:per_page) { 10 }
    let(:page) { 1 }
  
    context 'when the request is successful' do
      before do
        get :index, params: { search_term: search_term, per_page: per_page, page: page}
      end
      
      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      context "when there is default sorting order" do
        it 'returns formatted JSON in stars desc order' do
          json_response = JSON.parse(response.body)
          expect(json_response).not_to be_empty
          stars = json_response.collect{|j| j['stars']}
          is_desc = stars.each_cons(2).all? { |a, b| a >= b }
          expect(is_desc).to be_truthy
        end
      end
    end
  end
end
