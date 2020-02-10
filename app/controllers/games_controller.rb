require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(9)
  end

  def score
    session[:score] = 0 if session[:score].nil?
    @attempt = params[:word]
    @grid = params[:grid]
    @check = @attempt.upcase.chars.all? do |char|
      @grid.split(" ").count(char) >= @attempt.upcase.chars.count(char)
    end
    if @check
      url = 'https://wagon-dictionary.herokuapp.com/'
      api_return_hashed = JSON.parse(open("#{url}#{params[:word]}").read)
      if api_return_hashed['found']
        session[:score] += @attempt.length
        @message = "Congratulations ! #{@attempt.upcase} is a valid English word ! You score is now #{session[:score]}"
      else
        @message = "Sorry but #{@attempt.upcase} does not seem to be a valid English word..."
      end
    else
      @message = "Sorry but #{@attempt.upcase} can't be built out of #{@grid}"
    end
  end

  def generate_grid(grid_size)
    grid = []
    i = 1
    while i <= grid_size
      letter = ('A'..'Z').to_a.sample
      grid << letter
      i += 1
    end
     grid
  end
end
