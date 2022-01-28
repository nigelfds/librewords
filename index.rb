require 'sinatra'
require 'sinatra/cookies'
require './src/game'
require './src/stats'
require './src/formatter'


enable :sessions

get '/' do
    @stats = Stats.make(cookies[:stats])    
    @game = Game.make(session[:game])
    @error = session[:error]

    session[:game] = @game.to_s
    erb :game
end

post '/game' do
    @stats = Stats.make(cookies[:stats])
    @game = Game.make session[:game]    
    
    session[:error] = nil
    
    begin
        @game.play(params['guess'])
        @stats.add(@game) if @game.over? || @game.is_solved        
    rescue ArgumentError => e
        session[:error] = e.message
    end
    
    session[:game] = @game.to_s     
    cookies[:stats] = @stats.to_s
    logger.info session[:game]   
    
    redirect to('/')
end

post '/new_game' do
    session[:game] = nil
    session[:error] = nil
    redirect to('/')
end

