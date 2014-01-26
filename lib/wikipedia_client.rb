require 'httparty'

class WikipediaClient
  API_ENDPOINT = 'http://en.wikipedia.org/w/api.php'

  def initialize(title)
    @title = title
  end

  def extract
    response = make_request action: 'query', prop: 'extracts', exintro: 1

    response['query']['pages'].values.first['extract'].presence
  end

  private

  def make_request(query)
    default_query = {
      format: 'json',
      titles: @title,
      redirects: 1
    }
    HTTParty.get(API_ENDPOINT, query: default_query.merge(query))
  end
end
