class CaesarCipher
  attr_reader :alphabet

  def initialize(shift, shuffle = false, alphabet = [*('a'..'z'), *('A'..'Z'), *('а'..'я'), *('А'..'Я'), *('0'..'9')].join + ' ,.?!іїІЇж')
    if shuffle
      alphabet = alphabet.chars.shuffle.join
    end
    @alphabet = alphabet
    chars = @alphabet.chars.to_a
    @encrypter = Hash[chars.zip(chars.rotate(shift))]
    @decrypter = Hash[chars.zip(chars.rotate(-shift))]
  end

  def encrypt(string)
    transform(string, @encrypter)
  end

  def decrypt(string)
    transform(string, @decrypter)
  end

  def transform(string, hash)
    encrypted_chars = string.chars.map do |letter|
      raise "no '#{letter}' in alphabet" unless hash.has_key?(letter)
      hash[letter]
    end
    encrypted_chars.join
  end
end
