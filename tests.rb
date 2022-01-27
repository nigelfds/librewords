require "minitest/autorun"
require './src/words'
require './src/game'

class TestWords < Minitest::Test

  def test_that_simple_words_work
    assert Words.evaluate('storm','storm')[0]
    refute Words.evaluate('beard','storm')[0]   
  end

  def test_complex_guess_robot_against_stood
    target = "stood"
    guess = "robot"
    
    answer = ["R".white.on_black, 
             "O".yellow.on_black,
             "B".white.on_black,
             "O".green.on_black,
             "T".yellow.on_black].join
    actual = Words.evaluate(guess,target)[1]
    puts "\nTEST: Target #{target}, answer #{answer}, actual #{actual}"    
    assert_equal answer, actual
    
  end

  def test_complex_guess_stood_against_storm
    target = "storm"
    guess = "stood"
    
    answer = ["S".green.on_black, 
             "T".green.on_black,
             "O".green.on_black,
             "O".white.on_black,
             "D".white.on_black].join
    actual = Words.evaluate(guess,target)[1]
    puts "\nTEST: Target #{target}, answer #{answer}, actual #{actual}"    
    assert_equal answer, actual
  end

  def test_complex_guess_tarot_against_storm
    target = "storm"
    guess = "tarot"
    
    answer = ["T".yellow.on_black,
             "A".white.on_black,
             "R".yellow.on_black,
             "O".yellow.on_black,
             "T".white.on_black].join

    actual = Words.evaluate(guess,target)[1]
    puts "\nTEST: Target #{target}, answer #{answer}, actual #{actual}"    
    assert_equal answer, actual
  end

  def test_complex_guess_tarot_against_first
    target = "first"
    guess = "tarot"
    
    answer = ["T".white.on_black,
             "A".white.on_black,
             "R".green.on_black,
             "O".white.on_black,
             "T".green.on_black].join

    actual = Words.evaluate(guess,target)[1]
    puts "\nTEST: Target #{target}, answer #{answer}, actual #{actual}"    
    assert_equal answer, actual
  end

end


class TestGame < Minitest::Test
    def test_simple_game_serialization        
        game = Game.new 
        game.play 'magic'
        game.play 'crazy'

        game2 = Game.make game.to_s

        assert_equal game2.to_s, game.to_s               
    end

    def test_solving_a_game
        game = Game.new('target' => 'storm')
        game.play 'magic'
        game.play 'crazy'
        actual = game.play 'storm'
        
        answer = [
            "S".green.on_black,
            "T".green.on_black,
            "O".green.on_black,
            "R".green.on_black,
            "M".green.on_black].join

        assert actual[0]
        assert_equal answer, actual[1]
    end

    def test_exceed_a_game_attempts
        game = Game.new('target' => 'storm')
        game.play 'magic'
        game.play 'crazy'
        game.play 'rains'
        game.play 'fried'
        actual = game.play 'tarot'
        
        answer = [
            "T".yellow.on_black,
            "A".white.on_black,
            "R".yellow.on_black,
            "O".yellow.on_black,
            "T".white.on_black].join

        refute actual[0]
        assert_equal answer, actual[1]
    end
end