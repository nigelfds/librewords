require 'sinatra'
require 'sinatra/cookies'
require './src/game'
require './src/stats'
require './src/formatter'

configure do
    use Rack::Session::Cookie, :expire_after => 60*60*24*365
end


enable :sessions

get '/' do
    @stats = Stats.make(cookies[:stats2])
    @game = Game.make(session[:game], @stats.marker)
    @error = session[:error]
    session[:game] = @game.to_s
    erb :game
end

post '/game' do
    @stats = Stats.make(cookies[:stats2])
    @game = Game.make(session[:game], @stats.marker)        
    session[:error] = nil
    
    begin
        @game.play(params['guess'])        
        if @game.over? || @game.is_solved                
            @stats.add(
                {   
                    is_solved: @game.is_solved,
                    num_guesses: @game.guesses.length, 
                    game_no: @game.marker
                }) 
        end    
    rescue ArgumentError => e
        session[:error] = e.message
    end 

    session[:game] = @game.to_s         
    cookies[:stats2] = @stats.to_s
    logger.info session[:game]   
    redirect to('/')
end

post '/new_game' do
    @stats = Stats.make(cookies[:stats2])
    @stats.marker = @stats.marker + 1
    session[:game] = nil
    session[:error] = nil
    cookies[:stats2] = @stats.to_s
    redirect to('/')
end

