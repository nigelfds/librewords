require './src/game'

class Stats
    attr_accessor :marker

    def initialize params = {}
        @stats = params['stats'] || []                
        @marker = params['marker'] || 0
    end

    # stat = {is_solved, num_guesses, game_no}
    def add stat
        @stats.push stat
    end

    def to_s
        { stats: @stats, marker: @marker }.to_json
    end
    
    def self.make from_string = nil
        params = JSON.parse(from_string || '{}')
        Stats.new params
    end

    def total_played
        @stats.length
    end

    def solved
        @stats.select{|s| s['is_solved'] == true}.length
    end
end