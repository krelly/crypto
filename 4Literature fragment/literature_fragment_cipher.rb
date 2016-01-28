class LiteratureFragmentCipher

  def initialize(key)
    @letters_map = Hash.new {|h, k| h[k] = []}
    @key = key.lines

    @key[0, 100].each_with_index do |line, li|
      line[0, 100].each_char.with_index {|c, i| @letters_map[c] << sprintf("%.2d%.2d", li, i)}
    end
  end

  def encrypt(text)
    result = text.chars.map do |letter|
      abort "No '#{letter}' in provided fragment, aborting" unless @letters_map.has_key?(letter)
      @letters_map[letter].sample
    end
    result.join(' ')
  end

  def decrypt(text)
    result = text.split(' ').map do |code|
      line_index = code[0, 2].to_i
      letter_index = code[2, 2].to_i
      # p line_index,letter_index
      @key[line_index][letter_index]
    end
    result.join
  end

end
