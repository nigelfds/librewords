require 'colorize'
require "json"

class LibreWords
    DICT = File.readlines('dict.txt').map {|w| w.gsub("\n",'') }    

    def self.valid? guess
        guess.length == 5 && DICT.include?(guess.downcase)
    end

    def self.evaluate guess, target
        target_hash = target.chars.map.with_index { |x, i| [i, x] }.to_h
        remainder = {}

        greens = {}
        guess.downcase.chars.each.with_index do |char, index|
            if target[index] == char 
                greens[index] = char.dup                 
                target_hash.delete(target_hash.key char)
            else 
                remainder[index] =  char                
            end
        end  

        yellows = {}
        whites = {}
        remainder.each do |index, char|
            if target_hash.values.include? char
                yellows[index] = char.dup                 
                target_hash.delete(target_hash.key char)
            else
                whites[index] = char.dup
            end
        end
        
        output = {}
        greens.each do |index, char|
            output[index] = char.to_s.upcase.green
        end
        yellows.each do |index, char|
            output[index] = char.to_s.upcase.yellow
        end
        whites.each do |index, char|
            output[index] = char.to_s.upcase.white
        end
        
        [guess.downcase == target, output.keys.sort.map {|key| output[key] }.join.to_s.on_black]
    end    
end

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
        raise ArgumentError.new("Game Over") if over? || || @is_solved 
        raise ArgumentError.new("Invalid Word or length") unless LibreWords.valid?(guess)
                
        @guesses.push guess
        result = LibreWords.evaluate(guess, @target)
        
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
end

class Formatter
    ANSI_COLOR_CODE = {
        0 => 'black',
          1 => 'red',
          2 => 'green',
          3 => 'yellow',
          4 => 'blue',
          5 => 'purple',
          6 => 'cyan',
          7 => 'white'
      }
      
    def self.sanitize_ansi_data(data) 
        data.gsub!(/\033\[1m/,"<b>")
        data.gsub!(/\033\[0m/,"</b></span>")
        
        data.gsub!(/\033\[[\d\;]{2,}m.*?<\/b><\/span>/){ |data|
            span = "<span style='"
            content = ""
            /\033\[([\d\;]{2,})m(.*?)<\/b><\/span>/.match(data) {|m|
                content = m[2]
                m[1].split(";").each do |code|
                    #puts code
                    if match = /(\d)(\d)/.match(code) 
                        case match[1]
                        when "3"
                            span += "color: #{ANSI_COLOR_CODE[match[2].to_i]}; "
                        when "4"
                            span += "background-color: #{ANSI_COLOR_CODE[match[2].to_i]}; "
                        else
                            #do nothing
                        end
                    else
                        span += "font-weight:bold; "
                    end
                end
            }
            span += "'>"
            "#{span}#{content}</b></span>"
        }
        data
    end
end