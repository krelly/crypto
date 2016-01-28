class TrithemiusCipher
  attr_reader :alphabet

  def initialize(alphabet = [*('a'..'z'), *('A'..'Z'), *('а'..'я'), *('А'..'Я'), *('0'..'9')].join + ' ,.?!іїІЇж')
    @alphabet = alphabet
    @n = alphabet.size
  end

  def encrypt(string)
    transform(string, true, &Proc.new)
  end

  def decrypt(string)
    transform(string, false, &Proc.new)
  end

  private

  def transform(string, encrypt, &block)
    result = string.chars.map.with_index do |letter, i|
      m = @alphabet.index(letter)
      raise "no #{letter} in alphabet" if m.nil?
      k = yield(i, letter)

      if encrypt
        mk = m + k + 1
      else
        mk = m - k - 1
        while mk < 0
          mk += @n
        end
      end

      a = mk % @n
      @alphabet[a]
    end
    result.join
  end

end
