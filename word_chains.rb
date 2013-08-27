class WordChain
  DICTIONARY = File.readlines("dictionary.txt").map(&:chomp)

  def run
    words = input
    puts; puts find_chain(words[0],words[1])
  end

  # gets user input, ensuring word pair are of equal length
  def input
    puts "Choose a starting word!"
    starting = get_valid_word
    puts "Ok, choose ending word!"
    ending = get_valid_word
    until starting.length == ending.length
      puts "MUST BE THE SAME LENGTH AS STARTING WORD!!"
      puts "Ok, choose ending word!"
      ending = get_valid_word
    end
    [starting,ending]
  end

  # helper for getting user input, including word validation (word is in dictionary)
  def get_valid_word
    word = gets.chomp
    until is_valid_word?(word)
      puts "Be better."
      word = gets.chomp
    end
    word
  end

  # validates word by checking the dictionary
  def is_valid_word?(word)
    DICTIONARY.include?(word)
  end

  # finds word chain
  def find_chain(starting,ending)
    current_words = [starting]
    visited_words = [starting]
    all_adjacent_words = [starting]
    path = {nil => [starting]}

    until visited_words.include?(ending) || all_adjacent_words.empty?
      all_adjacent_words = []
      current_words.each do |word|
        adjacent_words = adjacent_words(word) - visited_words
        all_adjacent_words += adjacent_words
        visited_words = visited_words + adjacent_words
        path[word] = adjacent_words
        break if adjacent_words.include?(ending)
      end
      current_words = all_adjacent_words
    end

    all_adjacent_words.empty? ? "No solution found." : build_chain(path, ending)
  end

  # helper for find chain, builds word chain from path
  def build_chain(path, ending)
    key = path.select{ |key,value| value.include?(ending) }.keys.first
    chain = [key, ending]
    until key.nil?
      key = path.select{ |k,v| v.include?(key) }.keys.first
      chain.unshift(key)
    end
    chain.compact
  end

  # collects an array of all adjacent words
  def adjacent_words(origin)
    new_words = DICTIONARY.select { |word| origin.length == word.length }
    new_words.select { |word| adjacent_word?(origin, word) }
  end

  # verifies if a word of equal length is an adjacent word
  def adjacent_word?(origin, word)
    diff = 0
    word.length.times { |i| diff += 1 unless word[i - 1] == origin[i - 1] }
    diff == 1 ? true : false
  end

end

if __FILE__ == $PROGRAM_NAME
  w = WordChain.new
  w.run
end