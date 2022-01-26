require 'colorize'

class LibreWords
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