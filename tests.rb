require "minitest/autorun"
require './library'

class TestMeme < Minitest::Test

  def test_that_simple_words_work
    assert LibreWordle.evaluate('storm','storm')[0]
    refute LibreWordle.evaluate('beard','storm')[0]   
  end

  def test_complex_guess_robot_against_stood
    target = "stood"
    guess = "robot"
    
    answer = ["R".white.on_black, 
             "O".yellow.on_black,
             "B".white.on_black,
             "O".green.on_black,
             "T".yellow.on_black].join
    actual = LibreWordle.evaluate(guess,target)[1]
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
    actual = LibreWordle.evaluate(guess,target)[1]
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

    actual = LibreWordle.evaluate(guess,target)[1]
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

    actual = LibreWordle.evaluate(guess,target)[1]
    puts "\nTEST: Target #{target}, answer #{answer}, actual #{actual}"    
    assert_equal answer, actual
  end

end