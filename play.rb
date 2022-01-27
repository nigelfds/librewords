require 'csv'
require 'colorize'
require './library'

WORDS = File.readlines('words.txt').map {|w| w.gsub("\n",'') }
MAX_GUESSES = 6

def game 
    target = WORDS.sample        
    guesses = []
    is_solved = false    
    
    loop do 
        break if guesses.length == MAX_GUESSES || is_solved

        puts "Attempts left: #{MAX_GUESSES - guesses.length}. Enter 5 letter word".white.on_black
        guess = gets.chomp
    
        if (LibreWords.valid?(guess)) 
            guesses.push guess
            result = LibreWords.evaluate(guess, target)
            is_solved = result[0]
            puts "\n#{result[1]}\n\n"            
        else
            puts "Invalid Word or length\n".red.on_black
        end
        
    end
    is_solved ? puts("Well Done".green) : puts("Sorry. The word was #{target.upcase}".red)
end

game
