class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses
  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if letter.nil? || letter.empty? || !letter.match?(/[a-zA-Z]/)
      raise ArgumentError, "Invalid guess."
    end

    letter = letter.downcase
    # Check if the guessing repeats
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    # Check if the guessing is right
    if @word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end

    return true
  end

  def check_win_or_lose
    got_all_letters = true
    @word.each_char do |char|
      unless @guesses.include?(char)
        got_all_letters = false
        break
      end
    end

    if got_all_letters
      return :win
    end

    if @wrong_guesses.length >= 7
      return :lose
    end
    return :play
  end

  def word_with_guesses
    ans = ''
    @word.each_char do |char|
      ans += (@guesses.include?(char)) ? char : '-'
    end
    return ans
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
