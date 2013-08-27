class WordChain
  DICTIONARY = File.readlines("dictionary.txt").map(&:chomp)

  def run
    words = input
    p find_chain(words[0],words[1])
  end

  def input
    puts "Choose a starting word!"
    starting = get_valid_word
    puts "Ok, choose ending word!"
    ending = get_valid_word
    until starting.length == ending.length
      puts "MUST BE THE SAME LENGTH!!"
      puts "Choose a starting word!"
      starting = get_valid_word
      puts "Ok, choose ending word!"
      ending = get_valid_word
    end
    [starting,ending]
  end

  def get_valid_word
    word = gets.chomp
    until is_valid_word?(word)
      puts "Be better."
      word = gets.chomp
    end
    word
  end

  def is_valid_word?(word)
    DICTIONARY.include?(word)
  end

  def find_chain(starting,ending)
    current_words = [starting]
    visited_words = [starting]
    possible_words = [starting]
    path = {nil => [starting]}

    # debugger

    until visited_words.include?(ending) || possible_words.empty?
      current_words.each do |word|
        possible_words = adjacent_words(word) - visited_words
        visited_words = visited_words + possible_words
        path[word] = possible_words
        break if possible_words.include?(ending)
      end
      current_words = possible_words
    end

    if path.select{ |key,value| value.include?(ending) }.empty?
      "No solution found."
    else
      return build_chain(path, ending)
    end
  end

  def build_chain(path, ending)
    key = path.select { |key,value| value.include?(ending) }.keys[0]
    chain = [ending,key]
    until key.nil?
      key = path.select{ |k,v| v.include?(key) }.keys[0]
      chain << key
    end

    chain.reverse.compact
  end

  def adjacent_words(origin)
    new_words = DICTIONARY.select { |word| origin.length == word.length }
    new_words.select { |word| adjacent_word?(origin, word) }
  end

  def adjacent_word?(origin, word)
    diff = 0
    word.length.times do |i|
      diff += 1 unless word[i - 1] == origin[i - 1]
    end
    diff == 1 ? true : false
  end
end

if __FILE__ == $PROGRAM_NAME
  w = WordChain.new
  w.run
end