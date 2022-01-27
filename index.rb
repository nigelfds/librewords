require 'sinatra'
require './library'

enable :sessions

get '/' do    
    @game = Game.make(session[:game])
    @error = session[:error]

    session[:game] = @game.to_s
    erb :game
end

post '/game' do
    session[:error] = nil
    @game = Game.make session[:game]    
    begin
        @game.play(params['guess'])        
    rescue ArgumentError => e
        session[:error] = e.message
    end
    session[:game] = @game.to_s     
    logger.info session[:game]   
    redirect to('/')
end

post '/new_game' do
    session[:game] = nil
    redirect to('/')
end

