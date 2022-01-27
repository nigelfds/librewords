require 'json'
require './src/words'

class Game
    WORDS = File.readlines('words.txt').map {|w| w.gsub("\n",'') }
    MAX_GUESSES = 6
    attr_reader :is_solved, :results, :target

    def initialize params = {}
        @target = params['target'] || WORDS.sample        
        @guesses = params['guesses'] || []
        @results = params['results'] || []
        @is_solved = params['is_solved'] || false          
    end

    # returns an aray of [true/false,string]
    # where the first is game solves yes or no,
    # and the string is the evaluation of the guess or last guess (solved or finished)
    def play guess         
        raise ArgumentError.new("Game Over") if over? || @is_solved 
        raise ArgumentError.new("Invalid Word or length") unless Words.valid?(guess)
                
        @guesses.push guess
        result = Words.evaluate(guess, @target)
        
        @is_solved = result[0]        
        @results.push(result[1])        

        [@is_solved, result[1]]
    end

    def over?
        @guesses.length == MAX_GUESSES 
    end

    def to_s
        {target: @target, guesses: @guesses, is_solved: @is_solved, results: @results}.to_json
    end
    
    def self.make from_string = nil
        params = JSON.parse(from_string || '{}')
        Game.new params
    end

    def unused_letters        
        ('a'..'z').to_a - @guesses.join.downcase.split('').uniq
    end
end
