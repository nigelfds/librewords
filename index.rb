require 'sinatra'
require './library'

enable :sessions

get '/' do    
    @game = Game.make(session[:game])
    session[:game] = @game.to_s
    erb :game
end

post '/game' do
    @game = Game.make session[:game]
    begin
        @game.play(params['guess'])        
    rescue ArgumentError => e
        @error = e.message
    end
    session[:game] = @game.to_s        
    redirect to('/')
end

post '/new_game' do
    session[:game] = nil
    redirect to('/')
end

