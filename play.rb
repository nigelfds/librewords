require 'csv'
require 'colorize'
require './library'

DICT = File.readlines('dict.txt').map {|w| w.gsub("\n",'') }
MAX_GUESSES = 6

def game 
    data = CSV.read('lemma.csv', col_sep: ' ')
    words = data.map{|row| row[2] if row[2].length == 5}.compact    
    target = words.sample    
    guesses = []
    is_solved = false
    count = 1
    loop do 
        break if guesses.length == MAX_GUESSES || is_solved

        puts "#{count}. Enter 5 letter guess".white.on_black
        guess = gets.chomp
    
        if (LibreWords.valid?(guess)) 
            guesses.push guess
            result = LibreWords.evaluate(guess, target)
            is_solved = result[0]
            puts "\n#{result[1]}\n\n"
        else
            puts "Invalid Word or length\n".red.on_black
        end
        count =  count + 1
    end
    puts "Target: #{target.upcase}"
end

game
