class Stats
    attr_accessor :marker

    def initialize params = {}
        @games = params['games'] || []
        @marker = params['marker'] || 0
    end

    def add game
        @games.push game
    end

    def to_s
        { game: @games, marker: @marker }.to_json
    end
    
    def self.make from_string = nil
        params = JSON.parse(from_string || '{}')
        Stats.new params
    end
end