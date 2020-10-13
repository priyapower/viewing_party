class MovieController < ApplicationController
  def top_forty
    top_40 = []
    page = 1
    2.times do
      response = Faraday.get("https://api.themoviedb.org/3/discover/movie") do |faraday|
        faraday.params[:api_key] = ENV['MOVIE_API_KEY']
        faraday.params[:language] = 'en-US'
        faraday.params[:sort_by] = 'popularity.desc'
        faraday.params[:include_adult] = false
        faraday.params[:include_video] = false
        faraday.params[:page] = page
      end
      json = JSON.parse(response.body, symbolize_names: true)
      top_40 << json[:results]
      page += 1
    end
    @results = top_40.flatten.sort_by do |result|
      result[:vote_average]
    end.reverse
    require "pry"; binding.pry
  end

  def search
    all_results = []
    page = 1
    2.times do
      response = Faraday.get("https://api.themoviedb.org/3/search/movie") do |faraday|
        faraday.params[:api_key] = ENV['MOVIE_API_KEY']
        faraday.params[:language] = 'en-US'
        faraday.params[:query] = params[:query]
        faraday.params[:page] = 1
      end
      json = JSON.parse(response.body, symbolize_names: true)
      all_results << json[:results]
      page +=1
    end
    joined_results = all_results.flatten.sort_by do |result|
      result[:vote_average]
    end.reverse

    if joined_results.count > 40
      @results = joined_results[0..39]
    else
      @results = joined_results
    end
  end
end
