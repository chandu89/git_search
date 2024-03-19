class GithubApiService
    def initialize(search_term, sort_by, per_page, page, order)
      @search_term = search_term
      @sort_by = sort_by.presence || 'stars'
      @per_page = per_page.presence || 10
      @page = page.presence || 1
      @order = order.presence || 'desc'
    end
  
    def fetch_repositories
      uri = URI("#{GIT_REPO_URL}?q=#{@search_term}&sort=#{@sort_by}&order=#{@order}&per_page=#{@per_page}&page=#{@page}")
      response = Net::HTTP.get(uri)
      parse_response(response)
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
  