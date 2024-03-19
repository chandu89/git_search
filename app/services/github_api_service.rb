class GithubApiService
    def initialize(search_term, sort_by, per_page, page, order)
      @search_term = search_term
      @sort_by = sort_by.presence || 'stars'
      @per_page = per_page.presence || 10
      @page = page.presence || 1
      @order = order.presence || 'desc'
    end
  
    def fetch_repositories
      cache_key = "#{@search_term}-#{@sort_by}-#{@order}-#{@per_page}-#{@page}"
      repositories = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
        response = request_api
        parse_response(response)
      end
      repositories
    end
  
    private
  
    def request_api
      uri = URI("#{GIT_REPO_URL}?q=#{@search_term}&sort=#{@sort_by}&order=#{@order}&per_page=#{@per_page}&page=#{@page}")
      Net::HTTP.get(uri)
    end
  
    def parse_response(response)
      parsed_response = JSON.parse(response)
      return parsed_response if parsed_response['errors'].present?

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
  