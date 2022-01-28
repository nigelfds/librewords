class Stats
    def initialize params = {}
        @games = params['games'] || []
    end

    def add game
        @games.push game
    end

    def to_s
        {game: @games}.to_json
    end
    
    def self.make from_string = nil
        params = JSON.parse(from_string || '{}')
        Stats.new params
    end
end