class GammaCipher

  def initialize(alphabet = [*('a'..'z'), *('A'..'Z'), *('а'..'я'), *('А'..'Я'), *('0'..'9')].join + ' ,.?!іїґ')
    @alphabet = alphabet
    @n = alphabet.size
  end

  def encrypt(message, *args)
    key = genkey(message.length, *args)
    xor_strings(message, key)
  end

  def decrypt(message, *args)
    key = genkey(message.length, *args)
    xor_strings(message, key)
  end

  private

  def xor_strings(s, t)
    arr = s.split('')
    res = arr.map.with_index do |a, i|
      num = @alphabet.index(a) ^ @alphabet.index(t[i])
      @alphabet[num]
    end
    res.join
  end

  def genkey(length, a, b, c, d)
    key = 0
    str = ''
    length.times do |_|
      key += (Math.sin(a) * Math.atan(b) + c.to_f ** 2 / d.to_f).round
      if key > @n
        key = key % @n
      end
      str << @alphabet[key]
    end
    str
  end

end